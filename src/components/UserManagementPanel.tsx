import { useState } from "react";
import {
  Card, CardContent, CardHeader, CardTitle, CardDescription,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter, DialogDescription,
} from "@/components/ui/dialog";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { useToast } from "@/hooks/use-toast";
import { authService } from "@/services/auth-service";
import { sanitizeInput } from "@/lib/sanitize";
import type { UserRole, User } from "@/types/auth";
import { ROLE_LABELS } from "@/types/auth";
import {
  Shield, UserPlus, Plus, Pencil, Lock, Unlock, Trash2,
} from "lucide-react";

type PublicUser = Omit<User, "passwordHash" | "salt">;

const EMPTY_FORM = {
  userId: "",
  name: "",
  email: "",
  role: "student" as UserRole,
  department: "",
  password: "",
};

interface Props {
  onRefresh: () => void;
}

export default function UserManagementPanel({ onRefresh }: Props) {
  const { toast } = useToast();
  const [createOpen, setCreateOpen] = useState(false);
  const [editUser, setEditUser] = useState<PublicUser | null>(null);
  const [form, setForm] = useState({ ...EMPTY_FORM });

  const users = authService.getUsers();
  const update = (patch: Partial<typeof form>) => setForm((p) => ({ ...p, ...patch }));

  const handleCreate = async () => {
    if (!form.userId || !form.name || !form.password) {
      toast({ title: "Validation error", description: "User ID, name, and password are required.", variant: "destructive" });
      return;
    }
    const result = await authService.createUser({
      ...form,
      userId: sanitizeInput(form.userId),
      name: sanitizeInput(form.name),
      email: sanitizeInput(form.email),
      department: sanitizeInput(form.department),
    });
    toast({ title: result.success ? "Success" : "Error", description: result.message, variant: result.success ? "default" : "destructive" });
    if (result.success) {
      setCreateOpen(false);
      setForm({ ...EMPTY_FORM });
      onRefresh();
    }
  };

  const handleEdit = async () => {
    if (!editUser) return;
    const result = await authService.updateUser(editUser.id, {
      name: sanitizeInput(form.name),
      email: sanitizeInput(form.email),
      role: form.role,
      department: sanitizeInput(form.department),
    });
    toast({ title: result.success ? "Success" : "Error", description: result.message, variant: result.success ? "default" : "destructive" });
    if (result.success) { setEditUser(null); onRefresh(); }
  };

  const handleToggleLock = async (u: PublicUser) => {
    const result = await authService.toggleLock(u.id);
    toast({ title: result.success ? "Success" : "Error", description: result.message, variant: result.success ? "default" : "destructive" });
    if (result.success) onRefresh();
  };

  const handleDelete = (u: PublicUser) => {
    const result = authService.deleteUser(u.id);
    toast({ title: result.success ? "Success" : "Error", description: result.message, variant: result.success ? "default" : "destructive" });
    if (result.success) onRefresh();
  };

  const openEdit = (u: PublicUser) => {
    setForm({ userId: u.userId, name: u.name, email: u.email, role: u.role, department: u.department || "", password: "" });
    setEditUser(u);
  };

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle className="flex items-center gap-2">
            <Shield className="h-5 w-5" />
            User Management
          </CardTitle>
          <CardDescription>{users.length} accounts total</CardDescription>
        </div>

        <Dialog open={createOpen} onOpenChange={setCreateOpen}>
          <DialogTrigger asChild>
            <Button onClick={() => setForm({ ...EMPTY_FORM })}>
              <UserPlus className="mr-2 h-4 w-4" />
              Create User
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Create New User</DialogTitle>
              <DialogDescription>Fill in the details to create a new account.</DialogDescription>
            </DialogHeader>
            <UserFormFields form={form} update={update} showPassword />
            <DialogFooter>
              <Button className="w-full" onClick={handleCreate}>
                <Plus className="mr-2 h-4 w-4" />Create User
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
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
                <TableHead>Last Login</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {users.map((u) => (
                <TableRow key={u.id}>
                  <TableCell className="font-mono text-sm">{u.userId}</TableCell>
                  <TableCell>{u.name}</TableCell>
                  <TableCell><Badge variant="secondary">{ROLE_LABELS[u.role]}</Badge></TableCell>
                  <TableCell>{u.department}</TableCell>
                  <TableCell>
                    {u.isLocked ? (
                      <Badge variant="destructive">Locked</Badge>
                    ) : (
                      <Badge variant="outline" className="border-green-500 text-green-600">Active</Badge>
                    )}
                  </TableCell>
                  <TableCell className="text-xs text-muted-foreground">
                    {u.lastLogin ? new Date(u.lastLogin).toLocaleString() : "Never"}
                  </TableCell>
                  <TableCell>
                    <div className="flex justify-end gap-1">
                      <Button variant="ghost" size="icon" title="Edit" onClick={() => openEdit(u)}>
                        <Pencil className="h-4 w-4" />
                      </Button>
                      <Button
                        variant="ghost"
                        size="icon"
                        title={u.isLocked ? "Unlock" : "Lock"}
                        onClick={() => handleToggleLock(u)}
                      >
                        {u.isLocked ? <Unlock className="h-4 w-4" /> : <Lock className="h-4 w-4" />}
                      </Button>
                      <AlertDialog>
                        <AlertDialogTrigger asChild>
                          <Button variant="ghost" size="icon" title="Delete" className="text-destructive hover:text-destructive">
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </AlertDialogTrigger>
                        <AlertDialogContent>
                          <AlertDialogHeader>
                            <AlertDialogTitle>Delete {u.userId}?</AlertDialogTitle>
                            <AlertDialogDescription>
                              This will permanently remove {u.name}'s account. This action cannot be undone.
                            </AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Cancel</AlertDialogCancel>
                            <AlertDialogAction onClick={() => handleDelete(u)} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
                              Delete
                            </AlertDialogAction>
                          </AlertDialogFooter>
                        </AlertDialogContent>
                      </AlertDialog>
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </CardContent>

      {/* Edit dialog */}
      <Dialog open={!!editUser} onOpenChange={(open) => { if (!open) setEditUser(null); }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Edit User — {editUser?.userId}</DialogTitle>
            <DialogDescription>Update the user's details below.</DialogDescription>
          </DialogHeader>
          <UserFormFields form={form} update={update} showPassword={false} />
          <DialogFooter>
            <Button className="w-full" onClick={handleEdit}>
              <Pencil className="mr-2 h-4 w-4" />Save Changes
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </Card>
  );
}

function UserFormFields({
  form,
  update,
  showPassword,
}: {
  form: typeof EMPTY_FORM;
  update: (patch: Partial<typeof EMPTY_FORM>) => void;
  showPassword: boolean;
}) {
  return (
    <div className="space-y-3 pt-2">
      {showPassword && (
        <Field label="User ID">
          <Input value={form.userId} onChange={(e) => update({ userId: e.target.value })} placeholder="e.g. FAC002" />
        </Field>
      )}
      <Field label="Full Name">
        <Input value={form.name} onChange={(e) => update({ name: e.target.value })} />
      </Field>
      <Field label="Email">
        <Input value={form.email} onChange={(e) => update({ email: e.target.value })} type="email" />
      </Field>
      <Field label="Role">
        <Select value={form.role} onValueChange={(v) => update({ role: v as UserRole })}>
          <SelectTrigger><SelectValue /></SelectTrigger>
          <SelectContent>
            <SelectItem value="super_admin">Super Admin</SelectItem>
            <SelectItem value="admin">Admin</SelectItem>
            <SelectItem value="faculty">Faculty</SelectItem>
            <SelectItem value="student">Student</SelectItem>
          </SelectContent>
        </Select>
      </Field>
      <Field label="Department">
        <Input value={form.department} onChange={(e) => update({ department: e.target.value })} />
      </Field>
      {showPassword && (
        <Field label="Password">
          <Input value={form.password} onChange={(e) => update({ password: e.target.value })} type="password" />
        </Field>
      )}
    </div>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="space-y-1">
      <Label>{label}</Label>
      {children}
    </div>
  );
}
