import { useAuth } from "@/contexts/AuthContext";
import { BookOpen, ClipboardList, Calendar } from "lucide-react";
import { ProfileCard, PlaceholderCard } from "./FacultyDashboard";

export default function StudentDashboard() {
  const { user } = useAuth();

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold">Student Dashboard</h2>
        <p className="text-muted-foreground">Welcome, {user?.name}</p>
      </div>

      <ProfileCard user={user} fallbackRole="student" />

      <div className="grid gap-4 sm:grid-cols-3">
        <PlaceholderCard icon={BookOpen} title="My Courses" subtitle="Enrolled courses — coming soon" />
        <PlaceholderCard icon={ClipboardList} title="Results" subtitle="Academic results — coming soon" />
        <PlaceholderCard icon={Calendar} title="Attendance" subtitle="Attendance records — coming soon" />
      </div>
    </div>
  );
}
