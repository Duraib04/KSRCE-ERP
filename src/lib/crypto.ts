/**
 * Cryptographic helpers built on the Web Crypto API.
 *
 * - SHA-256 password hashing with per-user salt
 * - Constant-time comparison to prevent timing attacks
 * - Simulated HMAC-SHA256 JWT token generation / verification
 */

const HMAC_SECRET = "KSRCE-ERP-SECRET-2025-HMAC-KEY";

/** Convert a Uint8Array to a lowercase hex string. */
function toHex(bytes: Uint8Array): string {
  return Array.from(bytes, (b) => b.toString(16).padStart(2, "0")).join("");
}

/** Generate a cryptographically random 16-byte salt (hex). */
export function generateSalt(): string {
  return toHex(crypto.getRandomValues(new Uint8Array(16)));
}

/** Hash `password` with `salt` using SHA-256. */
export async function hashPassword(
  password: string,
  salt: string
): Promise<string> {
  const data = new TextEncoder().encode(salt + password);
  const digest = await crypto.subtle.digest("SHA-256", data);
  return toHex(new Uint8Array(digest));
}

/** Constant-time string comparison (prevents timing side-channels). */
export function constantTimeCompare(a: string, b: string): boolean {
  if (a.length !== b.length) {
    // Iterate anyway so the branch doesn't leak length info via timing.
    let sink = 1;
    for (let i = 0; i < a.length; i++)
      sink |= a.charCodeAt(i) ^ (b.charCodeAt(i % (b.length || 1)) || 0);
    void sink;
    return false;
  }
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

// ── JWT-like token helpers ──────────────────────────────────

function base64UrlEncode(str: string): string {
  return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function base64UrlDecode(str: string): string {
  let s = str.replace(/-/g, "+").replace(/_/g, "/");
  while (s.length % 4) s += "=";
  return atob(s);
}

async function sign(payload: string): Promise<string> {
  const data = new TextEncoder().encode(HMAC_SECRET + "." + payload);
  const digest = await crypto.subtle.digest("SHA-256", data);
  return toHex(new Uint8Array(digest));
}

/** Create a JWT-like token from an arbitrary payload. */
export async function generateToken(
  payload: Record<string, unknown>
): Promise<string> {
  const header = base64UrlEncode(JSON.stringify({ alg: "HS256", typ: "JWT" }));
  const body = base64UrlEncode(JSON.stringify(payload));
  const sig = await sign(`${header}.${body}`);
  return `${header}.${body}.${base64UrlEncode(sig)}`;
}

/** Verify and decode a JWT-like token. Returns `null` on failure. */
export async function verifyToken(
  token: string
): Promise<Record<string, unknown> | null> {
  try {
    const [header, body, sig] = token.split(".");
    if (!header || !body || !sig) return null;

    const expected = await sign(`${header}.${body}`);
    if (!constantTimeCompare(base64UrlDecode(sig), expected)) return null;

    const payload = JSON.parse(base64UrlDecode(body));
    if (payload.exp && Date.now() > payload.exp) return null;

    return payload;
  } catch {
    return null;
  }
}

/** Generate a unique ID (good enough for local mock data). */
export function generateId(): string {
  const rand = crypto.getRandomValues(new Uint32Array(2));
  return `${rand[0]}-${rand[1]}-${Date.now().toString(36)}`;
}
