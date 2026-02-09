import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { ROLE_LABELS } from "@/types/auth";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { LogOut, Shield, User } from "lucide-react";
import ksrceLogo from "@/assets/ksrce-logo.png";

export function Navbar() {
  const { user, logout, logoutAllSessions } = useAuth();
  const navigate = useNavigate();

  if (!user) return null;

  return (
    <header className="sticky top-0 z-50 border-b bg-primary text-primary-foreground">
      <div className="flex h-14 items-center justify-between px-4 md:px-6">
        {/* Branding */}
        <div
          className="flex items-center gap-3 cursor-pointer"
          onClick={() => navigate("/dashboard")}
        >
          <img
            src={ksrceLogo}
            alt="KSRCE Logo"
            className="h-8 w-8 rounded-full bg-white p-0.5 object-contain"
          />
          <div className="hidden sm:block">
            <h1 className="text-sm font-bold leading-tight tracking-wide">
              KSR COLLEGE OF ENGINEERING
            </h1>
            <p className="text-[10px] opacity-80 tracking-widest">
              TIRUCHENGODE — ERP SYSTEM
            </p>
          </div>
          <span className="sm:hidden text-xs font-bold">KSRCE ERP</span>
        </div>

        {/* User menu */}
        <div className="flex items-center gap-3">
          <div className="hidden md:flex flex-col items-end text-xs">
            <span className="font-medium">{user.name}</span>
            <span className="opacity-80">
              {ROLE_LABELS[user.role]} — {user.userId}
            </span>
          </div>

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button
                variant="ghost"
                size="icon"
                className="text-primary-foreground hover:bg-primary-foreground/10"
              >
                <User className="h-5 w-5" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-48">
              <div className="px-3 py-2 text-sm md:hidden">
                <p className="font-medium">{user.name}</p>
                <p className="text-muted-foreground text-xs">
                  {ROLE_LABELS[user.role]}
                </p>
              </div>
              <DropdownMenuSeparator className="md:hidden" />
              <DropdownMenuItem
                onClick={() => {
                  logout();
                  navigate("/login");
                }}
              >
                <LogOut className="mr-2 h-4 w-4" />
                Logout
              </DropdownMenuItem>
              <DropdownMenuItem
                onClick={() => {
                  logoutAllSessions();
                  navigate("/login");
                }}
              >
                <Shield className="mr-2 h-4 w-4" />
                Logout All Sessions
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </header>
  );
}
