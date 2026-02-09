import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { ShieldAlert } from "lucide-react";

export default function Unauthorized() {
  const navigate = useNavigate();

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <div className="text-center space-y-4">
        <ShieldAlert className="h-16 w-16 text-destructive mx-auto" />
        <h1 className="text-2xl font-bold">Access Denied</h1>
        <p className="text-muted-foreground">
          You do not have permission to access this page.
        </p>
        <div className="flex gap-3 justify-center">
          <Button onClick={() => navigate("/dashboard")}>Go to Dashboard</Button>
          <Button variant="outline" onClick={() => navigate("/login")}>
            Back to Login
          </Button>
        </div>
      </div>
    </div>
  );
}
