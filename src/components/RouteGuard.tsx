import { Navigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import type { UserRole, Permission } from "@/types/auth";

interface RouteGuardProps {
  children: React.ReactNode;
  allowedRoles?: UserRole[];
  requiredPermission?: Permission;
}

/**
 * Wraps a route element. Redirects to /login when unauthenticated
 * or /unauthorized when the user's role / permission is insufficient.
 */
export function RouteGuard({
  children,
  allowedRoles,
  requiredPermission,
}: RouteGuardProps) {
  const { isAuthenticated, isLoading, user, hasPermission } = useAuth();

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="animate-spin h-8 w-8 border-4 border-primary border-t-transparent rounded-full" />
      </div>
    );
  }

  if (!isAuthenticated || !user) return <Navigate to="/login" replace />;
  if (allowedRoles && !allowedRoles.includes(user.role))
    return <Navigate to="/unauthorized" replace />;
  if (requiredPermission && !hasPermission(requiredPermission))
    return <Navigate to="/unauthorized" replace />;

  return <>{children}</>;
}
