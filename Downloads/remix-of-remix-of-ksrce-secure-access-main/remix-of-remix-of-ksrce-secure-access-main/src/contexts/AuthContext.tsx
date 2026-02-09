import {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  useRef,
  type ReactNode,
} from "react";
import { useNavigate } from "react-router-dom";
import type { User, UserRole, Permission } from "@/types/auth";
import { ROLE_PERMISSIONS } from "@/types/auth";
import { authService } from "@/services/auth-service";
import { auditService } from "@/services/audit-service";

interface AuthContextValue {
  user: Omit<User, "passwordHash" | "salt"> | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (
    userId: string,
    password: string,
    rememberMe?: boolean
  ) => Promise<{
    success: boolean;
    message: string;
    remainingAttempts?: number;
    lockDuration?: number;
  }>;
  logout: () => void;
  logoutAllSessions: () => void;
  hasPermission: (permission: Permission) => boolean;
  hasRole: (role: UserRole) => boolean;
}

const AuthContext = createContext<AuthContextValue | null>(null);

const IDLE_TIMEOUT_MS = 15 * 60 * 1000; // 15 minutes

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthContextValue["user"]>(null);
  const [isLoading, setIsLoading] = useState(true);
  const idleTimer = useRef<ReturnType<typeof setTimeout>>();
  const navigate = useNavigate();

  // Restore persisted session on mount
  useEffect(() => {
    (async () => {
      try {
        const payload = await authService.validateSession();
        if (payload) {
          const raw = sessionStorage.getItem("current_user");
          if (raw) setUser(JSON.parse(raw));
        }
      } catch {
        /* invalid / expired session */
      } finally {
        setIsLoading(false);
      }
    })();
  }, []);

  // Auto-logout on idle
  const resetIdleTimer = useCallback(() => {
    if (idleTimer.current) clearTimeout(idleTimer.current);
    if (!user) return;

    idleTimer.current = setTimeout(() => {
      auditService.log({
        userId: user.userId,
        userName: user.name,
        action: "SESSION_TIMEOUT",
        details: "Auto-logout due to inactivity",
        success: true,
      });
      authService.logout(user.id);
      setUser(null);
      navigate("/login");
    }, IDLE_TIMEOUT_MS);
  }, [user, navigate]);

  useEffect(() => {
    if (!user) return;

    const events = ["mousedown", "keydown", "scroll", "touchstart"] as const;
    const handler = () => resetIdleTimer();

    events.forEach((e) => window.addEventListener(e, handler));
    resetIdleTimer();

    return () => {
      events.forEach((e) => window.removeEventListener(e, handler));
      if (idleTimer.current) clearTimeout(idleTimer.current);
    };
  }, [user, resetIdleTimer]);

  const login: AuthContextValue["login"] = async (
    userId,
    password,
    rememberMe = false
  ) => {
    const result = await authService.login(userId, password, rememberMe);
    if (result.success && result.user) setUser(result.user);
    return {
      success: result.success,
      message: result.message,
      remainingAttempts: result.remainingAttempts,
      lockDuration: result.lockDuration,
    };
  };

  const logout = () => {
    authService.logout(user?.id);
    setUser(null);
  };

  const logoutAllSessions = () => {
    authService.logoutAllSessions();
    setUser(null);
  };

  const hasPermission = (permission: Permission): boolean =>
    !!user && (ROLE_PERMISSIONS[user.role]?.includes(permission) ?? false);

  const hasRole = (role: UserRole): boolean => user?.role === role;

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: !!user,
        isLoading,
        login,
        logout,
        logoutAllSessions,
        hasPermission,
        hasRole,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within <AuthProvider>");
  return ctx;
}
