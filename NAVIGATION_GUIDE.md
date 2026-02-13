# Navigation System - Complete Guide

## Overview
The KSRCE ERP application uses **go_router** for navigation management with proper role-based routing for Student, Faculty, and Admin users.

---

## Route Structure

### 1. **Authentication Routes**
```
/login              - Login Page (entry point)
/register           - Registration Page (if implemented)
/forgot-password    - Password Recovery (if implemented)
```

### 2. **Student Routes**
```
/student-dashboard                    - Main Student Dashboard
├── /student-dashboard/profile        - Student Profile
├── /student-dashboard/courses        - My Courses & Materials
├── /student-dashboard/assignments    - Assignments
├── /student-dashboard/results        - Results & Grades
├── /student-dashboard/attendance     - Attendance
├── /student-dashboard/complaints     - Complaints
├── /student-dashboard/notifications  - Notifications
└── /student-dashboard/time-table     - Time Table
```

**Usage:**
```dart
context.go(StudentRoutes.dashboard);
context.push(StudentRoutes.courses);
```

### 3. **Faculty Routes**
```
/faculty-dashboard                         - Main Faculty Dashboard
├── /faculty-dashboard/my-classes          - My Classes
├── /faculty-dashboard/attendance-management - Mark Attendance
├── /faculty-dashboard/grades-management   - Manage Grades
└── /faculty-dashboard/schedule            - Teaching Schedule
```

**Usage:**
```dart
context.go(FacultyRoutes.dashboard);
context.push(FacultyRoutes.myClasses);
```

### 4. **Admin Routes**
```
/admin-dashboard                   - Main Admin Dashboard
├── /admin-dashboard/students      - Students Management
├── /admin-dashboard/faculty       - Faculty Management
├── /admin-dashboard/courses       - Courses Management
└── /admin-dashboard/settings      - System Settings
```

**Usage:**
```dart
context.go(AdminRoutes.dashboard);
context.push(AdminRoutes.studentsList);
```

---

## Navigation Methods

### Using named routes (Recommended)
```dart
// Using go_router constants
import 'package:go_router/go_router.dart';
import 'package:ksrce_erp/src/config/routes.dart';

// Navigate
context.go(StudentRoutes.dashboard);

// Navigate with push (adds to stack)
context.push(StudentRoutes.courses);

// Replace current route
context.replace(StudentRoutes.dashboard);
```

### Using NavigationService
```dart
import 'package:ksrce_erp/src/services/navigation_service.dart';

// Navigate to dashboard based on user role
NavigationService.navigateToDashboard(context);

// Navigate to login
NavigationService.navigateToLogin(context);

// Navigate back
NavigationService.goBack(context);
```

### Using AuthService
```dart
import 'package:ksrce_erp/src/services/auth_service.dart';

// Login
await AuthService.login(email, password, role);

// Logout
AuthService.logout();

// Check authentication
if (AuthService.isAuthenticated) {
  // User is logged in
}

// Get current role
UserRole role = AuthService.currentRole;
```

---

## Authentication Flow

### 1. Login Process
```
User enters credentials
    ↓
Login page validates
    ↓
AuthService.login() sets state
    ↓
Redirect to appropriate dashboard
    ↓
User can now navigate within their module
```

### 2. Logout Process
```
User clicks logout
    ↓
AuthService.logout() clears state
    ↓
Router redirect to login page
    ↓
All protected routes blocked
```

---

## Protected Routes

Routes are automatically protected through the `redirect` mechanism in go_router:

```dart
redirect: (context, state) {
  final isLoggingIn = state.matchedLocation == AuthRoutes.login;
  final isAuthenticated = AuthService.isAuthenticated;

  // Not authenticated → Redirect to login
  if (!isAuthenticated && !isLoggingIn) {
    return AuthRoutes.login;
  }

  // Already logged in → Can't access login page
  if (isAuthenticated && isLoggingIn) {
    return _getInitialRoute();
  }

  return null; // No redirect needed
}
```

---

## Testing Navigation

### Test Student Navigation
1. Login with prefix **S** (e.g., S20210001)
2. Verify redirected to `/student-dashboard`
3. Test all student sub-routes:
   - Click "My Courses" → `/student-dashboard/courses`
   - Click "Assignments" → `/student-dashboard/assignments`
   - Click "Results" → `/student-dashboard/results`
   - Click "Attendance" → `/student-dashboard/attendance`
   - Click "Complaints" → `/student-dashboard/complaints`
   - Click "Notifications" → `/student-dashboard/notifications`
   - Click "Time Table" → `/student-dashboard/time-table`
4. Click logout → Redirected to `/login`

### Test Faculty Navigation
1. Login with prefix **FAC** or **FA** or manually set role
2. Verify redirected to `/faculty-dashboard`
3. Test all faculty sub-routes:
   - Click "My Classes" → `/faculty-dashboard/my-classes`
   - Click "Attendance" → `/faculty-dashboard/attendance-management`
   - Click "Grades" → `/faculty-dashboard/grades-management`
   - Click "Schedule" → `/faculty-dashboard/schedule`
4. Click logout → Redirected to `/login`

### Test Admin Navigation
1. Login with prefix **ADM** (e.g., ADM001)
2. Verify redirected to `/admin-dashboard`
3. Test all admin sub-routes:
   - Click "Students" → `/admin-dashboard/students`
   - Click "Faculty" → `/admin-dashboard/faculty`
   - Click "Courses" → `/admin-dashboard/courses`
4. Click logout → Redirected to `/login`

---

## Common Issues & Solutions

### Issue: Getting "Page Not Found" Error
**Cause:** Route not properly imported or typo in route path

**Solution:**
```dart
// ✅ CORRECT
context.go(StudentRoutes.dashboard);

// ❌ WRONG
context.go('/student-dashboard-x'); // Typo
context.go('student-dashboard');    // Missing /
```

### Issue: Logout doesn't redirect to login
**Cause:** AuthService.logout() not called

**Solution:**
```dart
// ✅ CORRECT
TextButton(
  onPressed: () {
    AuthService.logout();  // Call this first
    context.go(AuthRoutes.login);
  },
  child: const Text('Logout'),
),

// ❌ WRONG
TextButton(
  onPressed: () {
    context.go(AuthRoutes.login); // Logout not called
  },
  child: const Text('Logout'),
),
```

### Issue: Can navigate to protected routes without login
**Cause:** AuthService not properly initialized

**Solution:**
- Ensure AuthService is properly imported
- Check that `AuthService.isAuthenticated` reflects actual state
- Verify redirect logic in main.dart router config

### Issue: Infinite redirect loop
**Cause:** Redirect condition always true

**Solution:**
```dart
// ✅ CORRECT - prevents infinite loop
if (!isAuthenticated && !isLoggingIn) {
  return AuthRoutes.login;
}

// ❌ WRONG - could cause infinite loop
if (!isAuthenticated) {
  return AuthRoutes.login; // Even if already on login page
}
```

---

## Navigation Best Practices

### 1. Use Named Routes
```dart
// ✅ GOOD
context.go(StudentRoutes.courses);

// ❌ BAD
context.go('/student-dashboard/courses');
```

### 2. Use Correct Navigation Method
```dart
// ✅ go() - Replace current route
context.go(StudentRoutes.courses);

// ✅ push() - Add to stack
context.push(StudentRoutes.courses);

// ❌ Always use go() for dashboards
context.push(StudentRoutes.dashboard); // Wrong, should use go()
```

### 3. Close Drawer Before Navigation
```dart
// ✅ GOOD
void _navigateTo(String route) {
  context.push(route);
  Navigator.pop(context); // Close drawer
}

// ❌ BAD
void _navigateTo(String route) {
  context.push(route);
  // Drawer not closed
}
```

### 4. Proper Logout Flow
```dart
// ✅ GOOD
void _logout() {
  AuthService.logout();        // 1. Clear auth state
  context.go(AuthRoutes.login); // 2. Navigate to login
}

// ❌ BAD
void _logout() {
  context.go(AuthRoutes.login); // Logout not cleared
}
```

### 5. Handle Navigation in dialogs
```dart
// ✅ GOOD
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);           // Close dialog
          AuthService.logout();              // Clear auth
          context.go(AuthRoutes.login);      // Navigate
        },
        child: const Text('Logout'),
      ),
    ],
  ),
);
```

---

## File Structure

All navigation configuration is centralized:

```
lib/src/
├── config/
│   └── routes.dart              ← Route constants
├── services/
│   ├── auth_service.dart        ← Authentication logic
│   └── navigation_service.dart  ← Navigation helpers
└── main.dart                    ← Router configuration
```

**Import in any page:**
```dart
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/navigation_service.dart';
```

---

## Testing Checklist

- [ ] Login page loads without authentication
- [ ] Student can login with S prefix
- [ ] Faculty can login with FAC/FA prefix
- [ ] Admin can login with ADM prefix
- [ ] Dashboard appears after successful login
- [ ] All drawer navigation items work
- [ ] All bottom nav items work
- [ ] logout clears auth state
- [ ] Redirect to login after logout works
- [ ] Cannot access protected routes without login
- [ ] Deep linking works (direct URL navigation)
- [ ] Back button works correctly
- [ ] Error pages display for invalid routes

---

## Debugging

Enable go_router debugging:

```dart
final GoRouter _router = GoRouter(
  debugLogDiagnostics: true, // Shows all routing operations
  // ... rest of config
);
```

Check auth state:
```dart
print('Is Authenticated: ${AuthService.isAuthenticated}');
print('Current Role: ${AuthService.currentRole}');
print('Current User: ${AuthService.currentUserId}');
```

---

**Last Updated:** February 13, 2026
**Status:** Ready for Testing
