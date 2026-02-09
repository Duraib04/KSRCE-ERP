import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { GraduationCap, Users } from "lucide-react";
import ksrceLogo from "@/assets/ksrce-logo.png";
import aBlockImg from "@/assets/ksrce-a-block.jpg";
import ietBlockImg from "@/assets/ksrce-iet-block.jpg";

const SLIDES = [
  { src: aBlockImg, alt: "KSRCE A Block", label: "A Block" },
  { src: ietBlockImg, alt: "KSRCE IET Block", label: "IET Block" },
];

export default function Index() {
  const { isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    if (isAuthenticated) navigate("/dashboard", { replace: true });
  }, [isAuthenticated, navigate]);

  // Auto-rotate slides
  useEffect(() => {
    const id = setInterval(() => setCurrent((p) => (p + 1) % SLIDES.length), 5000);
    return () => clearInterval(id);
  }, []);

  return (
    <div className="relative min-h-screen overflow-hidden bg-background">
      {/* Background slideshow */}
      {SLIDES.map((slide, i) => (
        <div
          key={slide.label}
          className="absolute inset-0 transition-opacity duration-1000 ease-in-out"
          style={{ opacity: i === current ? 1 : 0 }}
        >
          <img
            src={slide.src}
            alt={slide.alt}
            className="h-full w-full object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-black/40 to-black/70" />
        </div>
      ))}

      {/* Content overlay */}
      <div className="relative z-10 flex min-h-screen flex-col items-center justify-between px-4 py-8">
        {/* Header */}
        <header className="flex flex-col items-center gap-4 animate-fade-in">
          <img
            src={ksrceLogo}
            alt="KSRCE Logo"
            className="h-20 w-20 rounded-full bg-white p-1 object-contain shadow-lg md:h-24 md:w-24"
          />
          <div className="text-center text-white">
            <h1 className="text-2xl font-bold tracking-wide md:text-4xl drop-shadow-lg">
              KSR COLLEGE OF ENGINEERING
            </h1>
            <p className="mt-1 text-sm tracking-[0.3em] opacity-80 md:text-base">
              TIRUCHENGODE
            </p>
            <p className="mt-1 text-xs opacity-60 md:text-sm">
              (Autonomous Institution — Affiliated to Anna University)
            </p>
          </div>
        </header>

        {/* Center — slide indicators + tagline */}
        <div className="flex flex-col items-center gap-6 text-center text-white animate-fade-in" style={{ animationDelay: "0.3s" }}>
          <p className="max-w-lg text-lg font-medium leading-relaxed drop-shadow md:text-xl">
            Enterprise Resource Planning System
          </p>

          {/* Slide label */}
          <div className="flex items-center gap-3">
            {SLIDES.map((slide, i) => (
              <button
                key={slide.label}
                onClick={() => setCurrent(i)}
                className={`rounded-full px-3 py-1 text-xs font-semibold transition-all ${
                  i === current
                    ? "bg-white text-primary-foreground shadow"
                    : "bg-white/20 text-white hover:bg-white/30"
                }`}
              >
                {slide.label}
              </button>
            ))}
          </div>
        </div>

        {/* Login buttons */}
        <div className="flex flex-col items-center gap-4 animate-fade-in sm:flex-row" style={{ animationDelay: "0.6s" }}>
          <Button
            size="lg"
            className="min-w-[200px] gap-2 bg-white text-primary hover:bg-white/90 shadow-xl text-base font-semibold"
            onClick={() => navigate("/login/student")}
          >
            <GraduationCap className="h-5 w-5" />
            Student Login
          </Button>
          <Button
            size="lg"
            className="min-w-[200px] gap-2 shadow-xl text-base font-semibold"
            onClick={() => navigate("/login/faculty")}
          >
            <Users className="h-5 w-5" />
            Faculty / Admin Login
          </Button>
        </div>

        {/* Footer */}
        <p className="text-xs text-white/50 mt-4">
          © {new Date().getFullYear()} KSR College of Engineering. All rights reserved.
        </p>
      </div>
    </div>
  );
}
