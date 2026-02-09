import { useAuth } from "@/contexts/AuthContext";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ROLE_LABELS } from "@/types/auth";
import { GraduationCap, BookOpen, Calendar, User } from "lucide-react";

export default function FacultyDashboard() {
  const { user } = useAuth();

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold">Faculty Dashboard</h2>
        <p className="text-muted-foreground">Welcome, {user?.name}</p>
      </div>

      <ProfileCard user={user} fallbackRole="faculty" />

      <div className="grid gap-4 sm:grid-cols-3">
        <PlaceholderCard icon={BookOpen} title="My Courses" subtitle="Course management — coming soon" />
        <PlaceholderCard icon={GraduationCap} title="My Students" subtitle="Student records — coming soon" />
        <PlaceholderCard icon={Calendar} title="Timetable" subtitle="Schedule management — coming soon" />
      </div>
    </div>
  );
}

/* ── Shared sub-components ──────────────────────────────── */

function ProfileCard({
  user,
  fallbackRole,
}: {
  user: ReturnType<typeof useAuth>["user"];
  fallbackRole: string;
}) {
  const rows = [
    ["User ID", user?.userId, true],
    ["Name", user?.name],
    ["Email", user?.email],
    ["Department", user?.department],
  ] as const;

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <User className="h-5 w-5" />
          Profile Information
        </CardTitle>
      </CardHeader>
      <CardContent className="grid gap-3 sm:grid-cols-2 text-sm">
        {rows.map(([label, value, mono]) => (
          <div key={label} className="flex justify-between border-b pb-2">
            <span className="text-muted-foreground">{label}</span>
            <span className={`font-medium ${mono ? "font-mono" : ""}`}>
              {value ?? "—"}
            </span>
          </div>
        ))}
        <div className="flex justify-between border-b pb-2">
          <span className="text-muted-foreground">Role</span>
          <Badge variant="secondary">
            {ROLE_LABELS[(user?.role ?? fallbackRole) as keyof typeof ROLE_LABELS]}
          </Badge>
        </div>
        <div className="flex justify-between border-b pb-2">
          <span className="text-muted-foreground">Last Login</span>
          <span className="font-medium text-xs">
            {user?.lastLogin ? new Date(user.lastLogin).toLocaleString() : "N/A"}
          </span>
        </div>
      </CardContent>
    </Card>
  );
}

function PlaceholderCard({
  icon: Icon,
  title,
  subtitle,
}: {
  icon: React.ComponentType<{ className?: string }>;
  title: string;
  subtitle: string;
}) {
  return (
    <Card>
      <CardContent className="flex flex-col items-center gap-3 p-6">
        <Icon className="h-10 w-10 text-primary" />
        <div className="text-center">
          <p className="font-semibold">{title}</p>
          <p className="text-xs text-muted-foreground">{subtitle}</p>
        </div>
      </CardContent>
    </Card>
  );
}

export { ProfileCard, PlaceholderCard };
