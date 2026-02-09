/** Supported user roles in the ERP system. */
export type UserRole = "super_admin" | "admin" | "faculty" | "student";

/** Full user record stored in the auth service. */
export interface User {
  id: string;
  userId: string; // login handle, e.g. "SA001"
  name: string;
  email: string;
  role: UserRole;
  department?: string;
  passwordHash: string;
  salt: string;
  isLocked: boolean;
  failedAttempts: number;
  lockUntil: number | null;
  lastLogin: number | null;
  createdAt: number;
}

/** JWT-like payload embedded in tokens. */
export interface TokenPayload {
  sub: string;
  role: UserRole;
  userId: string;
  name: string;
  iat: number;
  exp: number;
  type: "access" | "refresh";
}

/** Pair of access + refresh tokens. */
export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
}

/** Return value from AuthService.login(). */
export interface LoginResult {
  success: boolean;
  message: string;
  user?: Omit<User, "passwordHash" | "salt">;
  tokens?: AuthTokens;
  remainingAttempts?: number;
  lockDuration?: number;
}

/** Single audit log record. */
export interface AuditLogEntry {
  id: string;
  timestamp: number;
  userId: string;
  userName: string;
  action: AuditAction;
  details: string;
  ipAddress: string;
  success: boolean;
}

export type AuditAction =
  | "LOGIN_ATTEMPT"
  | "LOGIN_SUCCESS"
  | "LOGIN_FAILED"
  | "LOGOUT"
  | "LOGOUT_ALL_SESSIONS"
  | "ROLE_CHANGE"
  | "ACCOUNT_LOCKED"
  | "ACCOUNT_UNLOCKED"
  | "ROUTE_ACCESS"
  | "USER_CREATED"
  | "USER_UPDATED"
  | "SESSION_TIMEOUT";

export type Permission =
  | "view_dashboard"
  | "manage_admins"
  | "manage_faculty"
  | "manage_students"
  | "view_audit_logs"
  | "manage_security_policies"
  | "view_profile"
  | "view_academics";

/** Least-privilege role → permission mapping. */
export const ROLE_PERMISSIONS: Record<UserRole, Permission[]> = {
  super_admin: [
    "view_dashboard",
    "manage_admins",
    "manage_faculty",
    "manage_students",
    "view_audit_logs",
    "manage_security_policies",
    "view_profile",
    "view_academics",
  ],
  admin: [
    "view_dashboard",
    "manage_faculty",
    "manage_students",
    "view_profile",
    "view_academics",
  ],
  faculty: ["view_dashboard", "view_profile", "view_academics"],
  student: ["view_dashboard", "view_profile", "view_academics"],
};

/** Human-readable role labels. */
export const ROLE_LABELS: Record<UserRole, string> = {
  super_admin: "Super Admin",
  admin: "Admin",
  faculty: "Faculty",
  student: "Student",
};
