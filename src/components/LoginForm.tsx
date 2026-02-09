import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { loginSchema, checkPasswordStrength, sanitizeInput } from "@/lib/sanitize";
import { authService } from "@/services/auth-service";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Eye, EyeOff, Lock, User, AlertTriangle, Loader2, ArrowLeft } from "lucide-react";
import ksrceLogo from "@/assets/ksrce-logo.png";

interface DemoCredential {
  label: string;
  id: string;
  password: string;
}

interface LoginFormProps {
  title: string;
  subtitle: string;
  allowedPrefixes: string[];
  placeholderId: string;
  demoCredentials: DemoCredential[];
}

export default function LoginForm({
  title,
  subtitle,
  allowedPrefixes,
  placeholderId,
  demoCredentials,
}: LoginFormProps) {
  const { isAuthenticated, login } = useAuth();
  const navigate = useNavigate();

  const [userId, setUserId] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [lockDuration, setLockDuration] = useState<number | null>(null);
  const [remainingAttempts, setRemainingAttempts] = useState<number | null>(null);

  const strength = password ? checkPasswordStrength(password) : null;

  useEffect(() => {
    if (isAuthenticated) navigate("/dashboard", { replace: true });
  }, [isAuthenticated, navigate]);

  useEffect(() => {
    const saved = authService.getRememberedUser();
    if (saved) {
      const prefix = saved.replace(/\d+$/, "").toUpperCase();
      if (allowedPrefixes.includes(prefix)) {
        setUserId(saved);
        setRememberMe(true);
      }
    }
  }, [allowedPrefixes]);

  useEffect(() => {
    if (!lockDuration || lockDuration <= 0) return;
    const id = setInterval(() => {
      setLockDuration((prev) => {
        if (prev && prev <= 1) { clearInterval(id); return null; }
        return prev ? prev - 1 : null;
      });
    }, 1_000);
    return () => clearInterval(id);
  }, [lockDuration]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setRemainingAttempts(null);

    const sanitizedId = sanitizeInput(userId);

    // Validate prefix
    const prefix = sanitizedId.replace(/\d+$/, "").toUpperCase();
    if (!allowedPrefixes.includes(prefix)) {
      setError(`Invalid User ID for this login portal. Please use the correct login page.`);
      return;
    }

    const parsed = loginSchema.safeParse({ userId: sanitizedId, password });
    if (!parsed.success) {
      setError(parsed.error.errors[0].message);
      return;
    }

    setIsSubmitting(true);
    try {
      await new Promise((r) => setTimeout(r, 600));
      const result = await login(sanitizedId, password, rememberMe);

      if (result.success) {
        navigate("/dashboard", { replace: true });
      } else {
        setError(result.message);
        if (result.lockDuration) setLockDuration(Math.ceil(result.lockDuration));
        if (result.remainingAttempts !== undefined) setRemainingAttempts(result.remainingAttempts);
      }
    } catch {
      setError("An unexpected error occurred. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const blockCopy = (e: React.ClipboardEvent) => e.preventDefault();

  return (
    <div className="flex min-h-screen items-center justify-center bg-secondary/30 p-4">
      <Card className="w-full max-w-md shadow-lg animate-scale-in">
        <CardHeader className="items-center space-y-3 bg-primary rounded-t-lg text-primary-foreground pb-6">
          <Button
            variant="ghost"
            size="sm"
            className="absolute left-4 top-4 text-primary-foreground/80 hover:text-primary-foreground hover:bg-white/10"
            onClick={() => navigate("/")}
          >
            <ArrowLeft className="h-4 w-4 mr-1" />
            Back
          </Button>
          <img
            src={ksrceLogo}
            alt="KSRCE Logo"
            className="h-16 w-16 rounded-full bg-white p-1 object-contain"
          />
          <div className="text-center">
            <h1 className="text-lg font-bold tracking-wide">{title}</h1>
            <p className="text-xs opacity-70 mt-1">{subtitle}</p>
          </div>
        </CardHeader>

        <CardContent className="pt-6">
          <form onSubmit={handleSubmit} className="space-y-4" noValidate>
            {error && (
              <Alert variant="destructive">
                <AlertTriangle className="h-4 w-4" />
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}

            {lockDuration && (
              <Alert>
                <Lock className="h-4 w-4" />
                <AlertDescription>
                  Account locked. Try again in <strong>{lockDuration}s</strong>
                </AlertDescription>
              </Alert>
            )}

            {remainingAttempts !== null && remainingAttempts > 0 && remainingAttempts <= 2 && (
              <Alert>
                <AlertTriangle className="h-4 w-4" />
                <AlertDescription>
                  Warning: {remainingAttempts} attempt{remainingAttempts !== 1 ? "s" : ""} remaining before lockout.
                </AlertDescription>
              </Alert>
            )}

            <div className="space-y-2">
              <Label htmlFor="userId">User ID</Label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  id="userId"
                  value={userId}
                  onChange={(e) => setUserId(e.target.value)}
                  placeholder={placeholderId}
                  className="pl-10"
                  autoComplete="username"
                  disabled={isSubmitting || !!lockDuration}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Enter your password"
                  className="pl-10 pr-10"
                  autoComplete="current-password"
                  disabled={isSubmitting || !!lockDuration}
                  onCopy={blockCopy}
                  onCut={blockCopy}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((v) => !v)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                  aria-label={showPassword ? "Hide password" : "Show password"}
                >
                  {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>

              {strength && (
                <div className="space-y-1">
                  <div className="flex gap-1">
                    {Array.from({ length: 5 }, (_, i) => (
                      <div
                        key={i}
                        className="h-1 flex-1 rounded-full transition-colors"
                        style={{
                          backgroundColor: i <= strength.score ? strength.color : "hsl(var(--muted))",
                        }}
                      />
                    ))}
                  </div>
                  <p className="text-xs text-muted-foreground">Strength: {strength.label}</p>
                </div>
              )}
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Checkbox
                  id="rememberMe"
                  checked={rememberMe}
                  onCheckedChange={(v) => setRememberMe(v === true)}
                  disabled={isSubmitting}
                />
                <Label htmlFor="rememberMe" className="text-sm cursor-pointer">Remember me</Label>
              </div>
              <div className="text-xs text-muted-foreground border rounded px-2 py-1">🔒 CAPTCHA</div>
            </div>

            <Button type="submit" className="w-full" disabled={isSubmitting || !!lockDuration}>
              {isSubmitting ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Authenticating…
                </>
              ) : (
                "Sign In"
              )}
            </Button>

            <div className="border rounded-lg p-3 mt-4 bg-muted/50">
              <p className="text-xs font-semibold text-muted-foreground mb-2">Demo Credentials:</p>
              <div className="grid grid-cols-2 gap-1 text-xs text-muted-foreground">
                {demoCredentials.map((c) => (
                  <span key={c.id} className="contents">
                    <span>{c.label}:</span>
                    <span>{c.id} / {c.password}</span>
                  </span>
                ))}
              </div>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
