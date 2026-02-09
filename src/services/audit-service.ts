/**
 * In-memory audit logging service.
 *
 * Captures security events (login attempts, logouts, role changes, etc.)
 * and supports filtering by action, user ID, or success status.
 * The log resets on page refresh — intentional for a client-side mock.
 */

import type { AuditLogEntry, AuditAction } from "@/types/auth";
import { generateId } from "@/lib/crypto";

const MAX_LOG_SIZE = 1_000;

class AuditService {
  private logs: AuditLogEntry[] = [];

  log(entry: {
    userId: string;
    userName: string;
    action: AuditAction;
    details: string;
    success: boolean;
  }): void {
    this.logs.unshift({
      id: generateId(),
      timestamp: Date.now(),
      userId: entry.userId,
      userName: entry.userName,
      action: entry.action,
      details: entry.details,
      ipAddress: `192.168.1.${Math.floor(Math.random() * 254 + 1)}`,
      success: entry.success,
    });

    if (this.logs.length > MAX_LOG_SIZE) {
      this.logs.length = MAX_LOG_SIZE;
    }
  }

  getLogs(filter?: {
    action?: AuditAction;
    userId?: string;
    success?: boolean;
  }): AuditLogEntry[] {
    let result = this.logs;

    if (filter?.action) {
      result = result.filter((l) => l.action === filter.action);
    }
    if (filter?.userId) {
      const q = filter.userId.toLowerCase();
      result = result.filter((l) => l.userId.toLowerCase().includes(q));
    }
    if (filter?.success !== undefined) {
      result = result.filter((l) => l.success === filter.success);
    }

    return result;
  }

  clearLogs(): void {
    this.logs = [];
  }
}

export const auditService = new AuditService();
