import { useState, useReducer } from "react";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
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
import { useAuth } from "@/contexts/AuthContext";
import { auditService } from "@/services/audit-service";
import { authService } from "@/services/auth-service";
import type { AuditAction } from "@/types/auth";
import UserManagementPanel from "@/components/UserManagementPanel";
import {
  Users,
  FileText,
  Activity,
  Clock,
  AlertTriangle,
  CheckCircle,
  XCircle,
  Shield,
} from "lucide-react";

export default function SuperAdminDashboard() {
  const { user } = useAuth();
  const [auditFilter, setAuditFilter] = useState<AuditAction | "">("");
  const [auditSearch, setAuditSearch] = useState("");
  const [, forceRefresh] = useReducer((x: number) => x + 1, 0);

  const users = authService.getUsers();
  const logs = auditService.getLogs({
    action: auditFilter || undefined,
    userId: auditSearch || undefined,
  });

  const stats = {
    totalUsers: users.length,
    lockedAccounts: users.filter((u) => u.isLocked).length,
    loginAttempts:
      auditService.getLogs({ action: "LOGIN_ATTEMPT" }).length +
      auditService.getLogs({ action: "LOGIN_SUCCESS" }).length +
      auditService.getLogs({ action: "LOGIN_FAILED" }).length,
    totalLogs: auditService.getLogs().length,
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold">Super Admin Dashboard</h2>
        <p className="text-muted-foreground">
          Welcome, {user?.name}. Full system access.
        </p>
      </div>

      {/* KPI cards */}
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {[
          { icon: Users, value: stats.totalUsers, label: "Total Users" },
          {
            icon: AlertTriangle,
            value: stats.lockedAccounts,
            label: "Locked Accounts",
            destructive: true,
          },
          { icon: Activity, value: stats.loginAttempts, label: "Login Attempts" },
          { icon: FileText, value: stats.totalLogs, label: "Audit Entries" },
        ].map(({ icon: Icon, value, label, destructive }) => (
          <Card key={label}>
            <CardContent className="flex items-center gap-3 p-4">
              <Icon
                className={`h-8 w-8 ${destructive ? "text-destructive" : "text-primary"}`}
              />
              <div>
                <p className="text-2xl font-bold">{value}</p>
                <p className="text-xs text-muted-foreground">{label}</p>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* User management panel */}
      <UserManagementPanel onRefresh={forceRefresh} />

      {/* Audit logs */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Audit Logs
          </CardTitle>
          <CardDescription>
            Security event log (in-memory — resets on refresh)
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex flex-wrap gap-3">
            <Input
              placeholder="Search by User ID…"
              value={auditSearch}
              onChange={(e) => setAuditSearch(e.target.value)}
              className="w-48"
            />
            <Select
              value={auditFilter}
              onValueChange={(v) => setAuditFilter(v as AuditAction | "")}
            >
              <SelectTrigger className="w-48">
                <SelectValue placeholder="Filter by action" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Actions</SelectItem>
                <SelectItem value="LOGIN_SUCCESS">Login Success</SelectItem>
                <SelectItem value="LOGIN_FAILED">Login Failed</SelectItem>
                <SelectItem value="LOGOUT">Logout</SelectItem>
                <SelectItem value="ACCOUNT_LOCKED">Account Locked</SelectItem>
                <SelectItem value="SESSION_TIMEOUT">Session Timeout</SelectItem>
                <SelectItem value="USER_CREATED">User Created</SelectItem>
              </SelectContent>
            </Select>
            <Button
              variant="outline"
              onClick={() => {
                setAuditFilter("");
                setAuditSearch("");
              }}
            >
              Clear
            </Button>
          </div>

          <div className="overflow-x-auto max-h-96 overflow-y-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Time</TableHead>
                  <TableHead>User</TableHead>
                  <TableHead>Action</TableHead>
                  <TableHead>Details</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>IP</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {logs.length === 0 ? (
                  <TableRow>
                    <TableCell
                      colSpan={6}
                      className="text-center text-muted-foreground py-8"
                    >
                      No audit entries found.
                    </TableCell>
                  </TableRow>
                ) : (
                  logs.slice(0, 50).map((log) => (
                    <TableRow key={log.id}>
                      <TableCell className="text-xs whitespace-nowrap">
                        <Clock className="inline h-3 w-3 mr-1" />
                        {new Date(log.timestamp).toLocaleString()}
                      </TableCell>
                      <TableCell className="font-mono text-sm">
                        {log.userId}
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline" className="text-xs">
                          {log.action.replace(/_/g, " ")}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-sm max-w-[200px] truncate">
                        {log.details}
                      </TableCell>
                      <TableCell>
                        {log.success ? (
                          <CheckCircle className="h-4 w-4 text-green-500" />
                        ) : (
                          <XCircle className="h-4 w-4 text-destructive" />
                        )}
                      </TableCell>
                      <TableCell className="font-mono text-xs">
                        {log.ipAddress}
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>

      {/* Security policy summary */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Shield className="h-5 w-5" />
            Security Policies
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid gap-3 sm:grid-cols-2 text-sm">
            {[
              ["Max Login Attempts", "5"],
              ["Base Lock Duration", "30 seconds"],
              ["Session Timeout", "15 minutes"],
              ["Token Expiry", "15 minutes"],
              ["Password Hashing", "SHA-256 + Salt"],
              ["Lockout Backoff", "Exponential"],
            ].map(([label, value]) => (
              <div key={label} className="flex justify-between border-b pb-2">
                <span className="text-muted-foreground">{label}</span>
                <span className="font-medium">{value}</span>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
