/**
 * Input sanitisation & validation helpers.
 *
 * - XSS-safe string cleaning
 * - Zod login schema
 * - Password strength meter
 */

import { z } from "zod";

/** Strip HTML tags, dangerous characters, and JS protocol strings. */
export function sanitizeInput(input: string): string {
  return input
    .replace(/<[^>]*>/g, "")
    .replace(/[<>'"&]/g, "")
    .replace(/javascript:/gi, "")
    .replace(/on\w+\s*=/gi, "")
    .trim();
}

/** Zod schema for the login form. */
export const loginSchema = z.object({
  userId: z
    .string()
    .min(1, "User ID is required")
    .max(20, "User ID must be under 20 characters")
    .regex(
      /^[a-zA-Z0-9_]+$/,
      "User ID may only contain letters, numbers, and underscores"
    ),
  password: z
    .string()
    .min(1, "Password is required")
    .max(128, "Password must be under 128 characters"),
});

export type LoginFormData = z.infer<typeof loginSchema>;

export interface PasswordStrength {
  score: number; // 0–4
  label: "Very Weak" | "Weak" | "Fair" | "Strong" | "Very Strong";
  color: string;
}

/** Evaluate the strength of `password` on a 0–4 scale. */
export function checkPasswordStrength(password: string): PasswordStrength {
  let score = 0;
  if (password.length >= 8) score++;
  if (password.length >= 12) score++;
  if (/[A-Z]/.test(password) && /[a-z]/.test(password)) score++;
  if (/[0-9]/.test(password)) score++;
  if (/[^A-Za-z0-9]/.test(password)) score++;
  score = Math.min(4, score);

  const labels: PasswordStrength["label"][] = [
    "Very Weak",
    "Weak",
    "Fair",
    "Strong",
    "Very Strong",
  ];
  const colors = [
    "hsl(0 84% 60%)",
    "hsl(25 95% 53%)",
    "hsl(45 93% 47%)",
    "hsl(142 71% 45%)",
    "hsl(142 76% 36%)",
  ];

  return { score, label: labels[score], color: colors[score] };
}
