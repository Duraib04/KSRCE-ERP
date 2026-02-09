/**
 * Mock authentication service.
 *
 * Pre-seeded users for every role, SHA-256 password hashing with per-user
 * salt, brute-force lockout (5 attempts, exponential back-off), and
 * JWT-like access/refresh token management.
 */

import type { User, LoginResult, AuthTokens, TokenPayload, UserRole } from "@/types/auth";
import {
  hashPassword,
  constantTimeCompare,
  generateToken,
  verifyToken,
  generateSalt,
  generateId,
} from "@/lib/crypto";
import { auditService } from "./audit-service";

// ── Constants ───────────────────────────────────────────────

const ACCESS_TOKEN_TTL = 15 * 60 * 1000; // 15 min
const REFRESH_TOKEN_TTL = 7 * 24 * 60 * 60 * 1000; // 7 days
const MAX_FAILED_ATTEMPTS = 5;
const BASE_LOCK_MS = 30_000; // 30 s, doubles each lockout cycle

// ── Seed data ───────────────────────────────────────────────

interface Seed {
  userId: string;
  name: string;
  email: string;
  role: UserRole;
  department: string;
  plainPassword: string;
}

const SEEDS: Seed[] = [
  {
    userId: "SA001",
    name: "Dr. K.S. Rangasamy",
    email: "superadmin@ksrce.ac.in",
    role: "super_admin",
    department: "Administration",
    plainPassword: "SuperAdmin@123",
  },
  {
    userId: "AD001",
    name: "Prof. R. Venkatesh",
    email: "admin@ksrce.ac.in",
    role: "admin",
    department: "Administration",
    plainPassword: "Admin@123",
  },
  {
    userId: "FAC001",
    name: "Dr. S. Priya",
    email: "priya.s@ksrce.ac.in",
    role: "faculty",
    department: "Computer Science",
    plainPassword: "Faculty@123",
  },
  {
    userId: "STU001",
    name: "Arun Kumar M",
    email: "arun.m@ksrce.ac.in",
    role: "student",
    department: "Computer Science",
    plainPassword: "Student@123",
  },
];

// ── Service ─────────────────────────────────────────────────

class AuthService {
  private users: User[] = [];
  private ready = false;
  private sessions = new Map<string, AuthTokens>();

  /** Lazily hash seed passwords on first call. */
  private async init(): Promise<void> {
    if (this.ready) return;

    for (const s of SEEDS) {
      const salt = generateSalt();
      const passwordHash = await hashPassword(s.plainPassword, salt);
      this.users.push({
        id: generateId(),
        userId: s.userId,
        name: s.name,
        email: s.email,
        role: s.role,
        department: s.department,
        passwordHash,
        salt,
        isLocked: false,
        failedAttempts: 0,
        lockUntil: null,
        lastLogin: null,
        createdAt: Date.now(),
      });
    }

    this.ready = true;
  }

  // ── Login ───────────────────────────────────────────────

  async login(
    userId: string,
    password: string,
    rememberMe = false
  ): Promise<LoginResult> {
    await this.init();

    const user = this.users.find(
      (u) => u.userId.toLowerCase() === userId.toLowerCase()
    );

    if (!user) {
      auditService.log({
        userId,
        userName: "Unknown",
        action: "LOGIN_FAILED",
        details: "User not found",
        success: false,
      });
      return { success: false, message: "Invalid credentials. Please try again." };
    }

    // Account locked?
    if (user.isLocked && user.lockUntil) {
      if (Date.now() < user.lockUntil) {
        const secs = Math.ceil((user.lockUntil - Date.now()) / 1000);
        return {
          success: false,
          message: `Account is temporarily locked. Try again in ${secs} seconds.`,
          lockDuration: secs,
        };
      }
      // Lock expired — reset
      user.isLocked = false;
      user.failedAttempts = 0;
      user.lockUntil = null;
      auditService.log({
        userId: user.userId,
        userName: user.name,
        action: "ACCOUNT_UNLOCKED",
        details: "Lock expired automatically",
        success: true,
      });
    }

    // Verify password
    const hash = await hashPassword(password, user.salt);
    if (!constantTimeCompare(hash, user.passwordHash)) {
      return this.handleFailedAttempt(user);
    }

    // Success — reset counters, issue tokens
    user.failedAttempts = 0;
    user.isLocked = false;
    user.lockUntil = null;
    user.lastLogin = Date.now();

    const tokens = await this.issueTokens(user, rememberMe);
    this.sessions.set(user.id, tokens);
    this.persistSession(user, tokens, rememberMe);

    auditService.log({
      userId: user.userId,
      userName: user.name,
      action: "LOGIN_SUCCESS",
      details: `Role: ${user.role}`,
      success: true,
    });

    return {
      success: true,
      message: "Login successful",
      user: this.publicUser(user),
      tokens,
    };
  }

  // ── Session management ──────────────────────────────────

  async validateSession(): Promise<TokenPayload | null> {
    const token = sessionStorage.getItem("access_token");
    if (!token) return null;

    const payload = await verifyToken(token);
    if (payload) return payload as unknown as TokenPayload;

    return this.tryRefresh();
  }

  logout(userId?: string): void {
    const raw = sessionStorage.getItem("current_user");
    if (raw) {
      const u = JSON.parse(raw);
      auditService.log({
        userId: u.userId,
        userName: u.name,
        action: "LOGOUT",
        details: "User logged out",
        success: true,
      });
      if (userId) this.sessions.delete(userId);
    }
    this.clearSession();
  }

  logoutAllSessions(): void {
    const raw = sessionStorage.getItem("current_user");
    if (raw) {
      const u = JSON.parse(raw);
      auditService.log({
        userId: u.userId,
        userName: u.name,
        action: "LOGOUT_ALL_SESSIONS",
        details: "All sessions terminated",
        success: true,
      });
    }
    this.sessions.clear();
    this.clearSession();
  }

  getRememberedUser(): string | null {
    return localStorage.getItem("remember_user");
  }

  // ── User CRUD (admin) ──────────────────────────────────

  getUsers(): Omit<User, "passwordHash" | "salt">[] {
    return this.users.map(({ passwordHash, salt, ...rest }) => rest);
  }

  async createUser(data: {
    userId: string;
    name: string;
    email: string;
    role: UserRole;
    department: string;
    password: string;
  }): Promise<{ success: boolean; message: string }> {
    await this.init();

    if (this.users.some((u) => u.userId.toLowerCase() === data.userId.toLowerCase())) {
      return { success: false, message: "User ID already exists" };
    }

    const salt = generateSalt();
    const passwordHash = await hashPassword(data.password, salt);

    this.users.push({
      id: generateId(),
      userId: data.userId,
      name: data.name,
      email: data.email,
      role: data.role,
      department: data.department,
      passwordHash,
      salt,
      isLocked: false,
      failedAttempts: 0,
      lockUntil: null,
      lastLogin: null,
      createdAt: Date.now(),
    });

    this.logCurrentUser("USER_CREATED", `Created ${data.userId} (${data.role})`);
    return { success: true, message: "User created successfully" };
  }

  async updateUser(
    targetId: string,
    data: { name?: string; email?: string; role?: UserRole; department?: string }
  ): Promise<{ success: boolean; message: string }> {
    await this.init();
    const target = this.users.find((u) => u.id === targetId);
    if (!target) return { success: false, message: "User not found" };

    if (data.name) target.name = data.name;
    if (data.email) target.email = data.email;
    if (data.role) target.role = data.role;
    if (data.department) target.department = data.department;

    this.logCurrentUser("USER_UPDATED", `Updated ${target.userId}`);
    return { success: true, message: "User updated successfully" };
  }

  async toggleLock(targetId: string): Promise<{ success: boolean; message: string }> {
    await this.init();
    const target = this.users.find((u) => u.id === targetId);
    if (!target) return { success: false, message: "User not found" };

    if (target.isLocked) {
      target.isLocked = false;
      target.failedAttempts = 0;
      target.lockUntil = null;
      this.logCurrentUser("ACCOUNT_UNLOCKED", `Unlocked ${target.userId}`);
      return { success: true, message: `${target.userId} unlocked` };
    } else {
      target.isLocked = true;
      target.lockUntil = Date.now() + 365 * 24 * 60 * 60 * 1000; // indefinite
      this.logCurrentUser("ACCOUNT_LOCKED", `Manually locked ${target.userId}`);
      return { success: true, message: `${target.userId} locked` };
    }
  }

  deleteUser(targetId: string): { success: boolean; message: string } {
    const idx = this.users.findIndex((u) => u.id === targetId);
    if (idx === -1) return { success: false, message: "User not found" };

    const target = this.users[idx];
    // Prevent deleting yourself
    const currentRaw = sessionStorage.getItem("current_user");
    if (currentRaw) {
      const current = JSON.parse(currentRaw);
      if (current.id === targetId) {
        return { success: false, message: "Cannot delete your own account" };
      }
    }

    this.users.splice(idx, 1);
    this.sessions.delete(targetId);
    this.logCurrentUser("USER_CREATED", `Deleted ${target.userId}`); // reusing closest action
    return { success: true, message: `${target.userId} deleted` };
  }

  // ── Private helpers ─────────────────────────────────────

  private logCurrentUser(action: import("@/types/auth").AuditAction, details: string): void {
    const raw = sessionStorage.getItem("current_user");
    if (raw) {
      const u = JSON.parse(raw);
      auditService.log({ userId: u.userId, userName: u.name, action, details, success: true });
    }
  }

  private handleFailedAttempt(user: User): LoginResult {
    user.failedAttempts++;
    const remaining = MAX_FAILED_ATTEMPTS - user.failedAttempts;

    auditService.log({
      userId: user.userId,
      userName: user.name,
      action: "LOGIN_FAILED",
      details: `Attempt ${user.failedAttempts}/${MAX_FAILED_ATTEMPTS}`,
      success: false,
    });

    if (user.failedAttempts >= MAX_FAILED_ATTEMPTS) {
      const multiplier = 2 ** (Math.floor(user.failedAttempts / MAX_FAILED_ATTEMPTS) - 1);
      const lockMs = BASE_LOCK_MS * multiplier;
      user.isLocked = true;
      user.lockUntil = Date.now() + lockMs;

      auditService.log({
        userId: user.userId,
        userName: user.name,
        action: "ACCOUNT_LOCKED",
        details: `Locked for ${lockMs / 1000}s after ${user.failedAttempts} failures`,
        success: false,
      });

      return {
        success: false,
        message: `Account locked. Try again in ${lockMs / 1000} seconds.`,
        lockDuration: lockMs / 1000,
        remainingAttempts: 0,
      };
    }

    return {
      success: false,
      message: `Invalid credentials. ${remaining} attempt${remaining !== 1 ? "s" : ""} remaining.`,
      remainingAttempts: remaining,
    };
  }

  private async issueTokens(user: User, rememberMe: boolean): Promise<AuthTokens> {
    const now = Date.now();

    const access: TokenPayload = {
      sub: user.id,
      role: user.role,
      userId: user.userId,
      name: user.name,
      iat: now,
      exp: now + ACCESS_TOKEN_TTL,
      type: "access",
    };

    const refresh: TokenPayload = {
      sub: user.id,
      role: user.role,
      userId: user.userId,
      name: user.name,
      iat: now,
      exp: now + (rememberMe ? REFRESH_TOKEN_TTL : ACCESS_TOKEN_TTL * 4),
      type: "refresh",
    };

    const [accessToken, refreshToken] = await Promise.all([
      generateToken(access as unknown as Record<string, unknown>),
      generateToken(refresh as unknown as Record<string, unknown>),
    ]);

    return { accessToken, refreshToken };
  }

  private async tryRefresh(): Promise<TokenPayload | null> {
    const rt = sessionStorage.getItem("refresh_token");
    if (!rt) return null;

    const payload = await verifyToken(rt);
    if (!payload || payload.type !== "refresh") {
      this.clearSession();
      return null;
    }

    const user = this.users.find((u) => u.id === payload.sub);
    if (!user) {
      this.clearSession();
      return null;
    }

    const tokens = await this.issueTokens(user, false);
    sessionStorage.setItem("access_token", tokens.accessToken);
    sessionStorage.setItem("refresh_token", tokens.refreshToken);
    this.sessions.set(user.id, tokens);

    const fresh = await verifyToken(tokens.accessToken);
    return fresh as unknown as TokenPayload;
  }

  private persistSession(user: User, tokens: AuthTokens, rememberMe: boolean): void {
    sessionStorage.setItem("access_token", tokens.accessToken);
    sessionStorage.setItem("refresh_token", tokens.refreshToken);
    sessionStorage.setItem(
      "current_user",
      JSON.stringify({
        id: user.id,
        userId: user.userId,
        name: user.name,
        email: user.email,
        role: user.role,
        department: user.department,
        lastLogin: user.lastLogin,
      })
    );

    if (rememberMe) localStorage.setItem("remember_user", user.userId);
    else localStorage.removeItem("remember_user");
  }

  private publicUser(user: User): Omit<User, "passwordHash" | "salt"> {
    const { passwordHash, salt, ...rest } = user;
    return rest;
  }

  private clearSession(): void {
    sessionStorage.removeItem("access_token");
    sessionStorage.removeItem("refresh_token");
    sessionStorage.removeItem("current_user");
  }
}

export const authService = new AuthService();
