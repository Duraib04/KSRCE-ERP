import { Navigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { Navbar } from "@/components/Navbar";
import SuperAdminDashboard from "./SuperAdminDashboard";
import AdminDashboard from "./AdminDashboard";
import FacultyDashboard from "./FacultyDashboard";
import StudentDashboard from "./StudentDashboard";

const DASHBOARD_BY_ROLE = {
  super_admin: SuperAdminDashboard,
  admin: AdminDashboard,
  faculty: FacultyDashboard,
  student: StudentDashboard,
} as const;

export default function Dashboard() {
  const { user, isLoading } = useAuth();

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="animate-spin h-8 w-8 border-4 border-primary border-t-transparent rounded-full" />
      </div>
    );
  }

  if (!user) return <Navigate to="/login" replace />;

  const RoleDashboard = DASHBOARD_BY_ROLE[user.role];

  return (
    <div className="min-h-screen bg-secondary/20">
      <Navbar />
      <main className="container mx-auto p-4 md:p-6">
        <RoleDashboard />
      </main>
    </div>
  );
}
