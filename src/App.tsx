import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "@/contexts/AuthContext";
import { RouteGuard } from "@/components/RouteGuard";
import Index from "@/pages/Index";
import StudentLogin from "@/pages/StudentLogin";
import FacultyLogin from "@/pages/FacultyLogin";
import Dashboard from "@/pages/Dashboard";
import Unauthorized from "@/pages/Unauthorized";
import NotFound from "@/pages/NotFound";

const queryClient = new QueryClient();

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <AuthProvider>
            <Routes>
              <Route path="/" element={<Index />} />
              <Route path="/login/student" element={<StudentLogin />} />
              <Route path="/login/faculty" element={<FacultyLogin />} />
              <Route
                path="/dashboard"
                element={
                  <RouteGuard>
                    <Dashboard />
                  </RouteGuard>
                }
              />
              <Route path="/unauthorized" element={<Unauthorized />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </AuthProvider>
        </BrowserRouter>
      </TooltipProvider>
    </QueryClientProvider>
  );
}
