import { useState } from "react";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { authService } from "@/services/auth-service";
import { sanitizeInput } from "@/lib/sanitize";
import type { UserRole } from "@/types/auth";
import { ROLE_LABELS } from "@/types/auth";
import { Users, Plus, UserPlus } from "lucide-react";

const EMPTY_FORM = {
  userId: "",
  name: "",
  email: "",
  role: "student" as UserRole,
  department: "",
  password: "",
};

export default function AdminDashboard() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [form, setForm] = useState({ ...EMPTY_FORM });

  const users = authService
    .getUsers()
    .filter((u) => u.role === "faculty" || u.role === "student");

  const handleCreate = async () => {
    if (!form.userId || !form.name || !form.password) {
      toast({
        title: "Validation error",
        description: "User ID, name, and password are required.",
        variant: "destructive",
      });
      return;
    }

    const result = await authService.createUser({
      ...form,
      userId: sanitizeInput(form.userId),
      name: sanitizeInput(form.name),
      email: sanitizeInput(form.email),
      department: sanitizeInput(form.department),
    });

    toast({
      title: result.success ? "Success" : "Error",
      description: result.message,
      variant: result.success ? "default" : "destructive",
    });

    if (result.success) {
      setDialogOpen(false);
      setForm({ ...EMPTY_FORM });
    }
  };

  const update = (patch: Partial<typeof form>) =>
    setForm((prev) => ({ ...prev, ...patch }));

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold">Admin Dashboard</h2>
          <p className="text-muted-foreground">
            Welcome, {user?.name}. Manage faculty & students.
          </p>
        </div>

        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
          <DialogTrigger asChild>
            <Button>
              <UserPlus className="mr-2 h-4 w-4" />
              Create User
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Create New User</DialogTitle>
            </DialogHeader>
            <div className="space-y-3 pt-2">
              <Field label="User ID">
                <Input
                  value={form.userId}
                  onChange={(e) => update({ userId: e.target.value })}
                  placeholder="e.g. FAC002"
                />
              </Field>
              <Field label="Full Name">
                <Input
                  value={form.name}
                  onChange={(e) => update({ name: e.target.value })}
                />
              </Field>
              <Field label="Email">
                <Input
                  value={form.email}
                  onChange={(e) => update({ email: e.target.value })}
                  type="email"
                />
              </Field>
              <Field label="Role">
                <Select
                  value={form.role}
                  onValueChange={(v) => update({ role: v as UserRole })}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="faculty">Faculty</SelectItem>
                    <SelectItem value="student">Student</SelectItem>
                  </SelectContent>
                </Select>
              </Field>
              <Field label="Department">
                <Input
                  value={form.department}
                  onChange={(e) => update({ department: e.target.value })}
                />
              </Field>
              <Field label="Password">
                <Input
                  value={form.password}
                  onChange={(e) => update({ password: e.target.value })}
                  type="password"
                />
              </Field>
              <Button className="w-full" onClick={handleCreate}>
                <Plus className="mr-2 h-4 w-4" />
                Create User
              </Button>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Users className="h-5 w-5" />
            Faculty & Student Accounts
          </CardTitle>
          <CardDescription>{users.length} accounts managed</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>User ID</TableHead>
                  <TableHead>Name</TableHead>
                  <TableHead>Role</TableHead>
                  <TableHead>Department</TableHead>
                  <TableHead>Status</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {users.map((u) => (
                  <TableRow key={u.id}>
                    <TableCell className="font-mono text-sm">{u.userId}</TableCell>
                    <TableCell>{u.name}</TableCell>
                    <TableCell>
                      <Badge variant="secondary">{ROLE_LABELS[u.role]}</Badge>
                    </TableCell>
                    <TableCell>{u.department}</TableCell>
                    <TableCell>
                      {u.isLocked ? (
                        <Badge variant="destructive">Locked</Badge>
                      ) : (
                        <Badge
                          variant="outline"
                          className="border-green-500 text-green-600"
                        >
                          Active
                        </Badge>
                      )}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

/** Thin wrapper to keep the form DRY. */
function Field({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="space-y-1">
      <Label>{label}</Label>
      {children}
    </div>
  );
}
