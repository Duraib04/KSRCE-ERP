# KSRCE ERP - Deployment Guide

Complete guide for deploying the KSRCE ERP Flutter web application to production.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Deployment](#local-deployment)
3. [Vercel Deployment](#vercel-deployment)
4. [GitHub Actions CI/CD](#github-actions-cicd)
5. [Environment Configuration](#environment-configuration)
6. [Custom Domain Setup](#custom-domain-setup)
7. [Production Monitoring](#production-monitoring)
8. [Rollback Procedures](#rollback-procedures)
9. [Security Checklist](#security-checklist)

---

## Prerequisites

### Required Accounts

- **Vercel Account**: https://vercel.com (free or pro tier)
- **GitHub Account**: https://github.com with repository access
- **Domain Name**: (Optional but recommended for production)
- **API Server**: Backend running independently (Node.js, Django, etc.)
- **MySQL Database**: Production database instance

### Required Tools

```bash
# Flutter SDK 3.0.0+
flutter --version

# Dart SDK 3.0.0+
dart --version

# Node.js 16+ (for Vercel CLI)
node --version

# npm 7+ (for package management)
npm --version

# Git 2.30+ (for version control)
git --version
```

### Required Environment Variables

Create a `.env.example` file with these variables:

```env
# API Configuration
API_BASE_URL=https://api.yourdomain.com
API_TIMEOUT=30000

# Environment
FLUTTER_ENV=production
ENABLE_LOGGING=false

# Feature Flags
ENABLE_OFFLINE_MODE=true
ENABLE_BACKGROUND_SYNC=true
CACHE_EXPIRY_HOURS=24

# Analytics (Optional)
ANALYTICS_ID=
SENTRY_DSN=
```

---

## Local Deployment

### Step 1: Setup Local Environment

```bash
# Navigate to project directory
cd /path/to/KSRCE-ERP

# Install Flutter dependencies
flutter pub get

# Update pubspec.yaml if needed
flutter pub upgrade

# Clean build cache
flutter clean

# Get Flutter again after clean
flutter pub get
```

### Step 2: Configure Local Development Server

```bash
# Run development server on port 8080
flutter run -d chrome --web-port=8080

# Or run with specific release build
flutter run -d chrome -v

# Alternative: Run web server
webdev serve --port 8080
```

### Step 3: Test Locally

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Analyze code
flutter analyze

# Check format
dart format lib/

# Build production web
flutter build web --release
```

### Step 4: Local Build Artifacts

The `flutter build web --release` command generates:

```
build/web/
├── index.html
├── main.dart.js
├── styles.css
├── assets/
│   ├── images/
│   ├── fonts/
│   └── packages/
├── flutter_service_worker.js
└── manifest.json
```

---

## Vercel Deployment

### Step 1: Create Vercel Account

1. Visit https://vercel.com
2. Sign up with GitHub account
3. Authorize Vercel to access your repositories
4. Create new project

### Step 2: Connect GitHub Repository

```bash
# 1. Push code to GitHub
git add .
git commit -m "Ready for Vercel deployment"
git push origin main

# 2. In Vercel Dashboard:
# - Click "Import Project"
# - Select GitHub repository
# - Select "KSRCE-ERP" project
```

### Step 3: Configure Vercel Project

**Project Settings:**

- Framework: None (Flutter web)
- Build Command: `flutter build web --release`
- Output Directory: `build/web`
- Install Command: Skip (Flutter handles dependencies)

### Step 4: Environment Variables

In Vercel Dashboard → Settings → Environment Variables:

```env
API_BASE_URL=https://api.yourdomain.com
FLUTTER_ENV=production
ENABLE_OFFLINE_MODE=true
ENABLE_BACKGROUND_SYNC=true
CACHE_EXPIRY_HOURS=24
```

### Step 5: Deploy

```bash
# Install Vercel CLI (one-time)
npm install -g vercel

# Login to Vercel (one-time)
vercel login

# Deploy to staging
vercel --scope=your-org-id

# Deploy to production
vercel --prod --scope=your-org-id
```

**Vercel CLI Output:**

```
Vercel CLI 28.0.0
> Ready! Assigned to https://ksrce-team.vercel.app [in 2.3s]
> Building...
> Generated successfully in 45s
> Deployed to production [in 3.2s]
```

---

## GitHub Actions CI/CD

### Step 1: Add Vercel Secrets to GitHub

Repository Settings → Secrets and variables → Actions → New repository secret:

```
VERCEL_TOKEN=<your-vercel-token>
VERCEL_ORG_ID=<your-org-id>
VERCEL_PROJECT_ID=<your-project-id>
API_BASE_URL=https://api.yourdomain.com
STAGING_API_BASE_URL=https://staging-api.yourdomain.com
```

**To get Vercel credentials:**

```bash
# Generate Vercel token
vercel tokens create

# Get org and project IDs
vercel projects list --json
```

### Step 2: Workflow Triggers

The `.github/workflows/deploy.yml` triggers on:

```yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
```

**Deployment Flow:**

```
main branch push
    ↓
    [Build & Test]
    ↓
    [Deploy to Production] ✨
    
develop branch push
    ↓
    [Build & Test]
    ↓
    [Deploy to Staging]
```

### Step 3: Monitor CI/CD

```bash
# View workflow status
# GitHub Actions tab → Deploy workflow → Latest run

# View logs
# Click on workflow run → Get output logs

# Manual re-trigger
# Actions tab → Select workflow → Re-run jobs
```

---

## Environment Configuration

### Step 1: Create Environment-Specific Config

**lib/src/core/config/environment_config.dart:**

```dart
class EnvironmentConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const bool isProduction = String.fromEnvironment(
    'FLUTTER_ENV',
  ).toLowerCase() == 'production';

  static const bool enableOfflineMode = String.fromEnvironment(
    'ENABLE_OFFLINE_MODE',
    defaultValue: 'true',
  ).toLowerCase() == 'true';

  static const int cacheExpiryHours = int.fromEnvironment(
    'CACHE_EXPIRY_HOURS',
    defaultValue: 24,
  );
}
```

### Step 2: Build with Environment Variables

```bash
# Development build
flutter build web \
  --dart-define=API_BASE_URL=http://localhost:3000 \
  --dart-define=FLUTTER_ENV=development

# Production build
flutter build web --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=FLUTTER_ENV=production

# Staging build
flutter build web --release \
  --dart-define=API_BASE_URL=https://staging-api.yourdomain.com \
  --dart-define=FLUTTER_ENV=staging
```

---

## Custom Domain Setup

### Step 1: Point Domain to Vercel

**For domain registrar (GoDaddy, Namecheap, etc.):**

Update DNS records:

```
Type     | Name | Value
---------|------|------------------
CNAME    | www  | cname.vercel.app
A        | @    | 76.76.19.131
AAAA     | @    | 2610:7f8:3::3:0:1
TXT      | @    | v=spf1 ~all
```

### Step 2: Configure Vercel Domain

Vercel Dashboard → Domains:

1. Click "Add Domain"
2. Enter your domain (e.g., erp.yourdomain.com)
3. Select project
4. Configure DNS or change nameservers
5. Wait for DNS propagation (5-48 hours)

### Step 3: Enable HTTPS

Vercel automatically:

- Provisions SSL/TLS certificate (Let's Encrypt)
- Enables HTTPS-only redirect
- Sets security headers
- Handles certificate renewal

### Step 4: Configure Apex Domain Redirect

To redirect `yourdomain.com` → `erp.yourdomain.com`:

**Vercel Rules:**

```json
{
  "rules": [
    {
      "src": "/.*",
      "dest": "https://erp.yourdomain.com/:splat",
      "statusCode": 301
    }
  ]
}
```

---

## Production Monitoring

### Step 1: Enable Error Tracking (Sentry)

```bash
# Install Sentry package
flutter pub add sentry_flutter

# Initialize in main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://your-sentry-dsn@sentry.io/project-id';
      options.environment = 'production';
      options.tracesSampleRate = 0.1;
    },
    appRunner: () => runApp(const MyApp()),
  );
}
```

### Step 2: Setup Analytics

**Using Firebase Analytics (optional):**

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;

// Log custom events
await analytics.logEvent(
  name: 'user_login',
  parameters: {'user_role': 'student'},
);
```

### Step 3: Monitor Performance

**Key Metrics to Track:**

- Page load time (target: < 3 seconds)
- API response time (target: < 1 second)
- Error rate (target: < 0.1%)
- Offline conversion (target: > 95%)
- Cache hit rate (target: > 80%)

### Step 4: View Logs

```bash
# Vercel CLI: Real-time logs
vercel logs my-project-name

# GitHub Actions: Build outputs
# Actions tab → Workflow run → Log output

# Browser Console: Client-side errors
# DevTools → Console tab
```

---

## Rollback Procedures

### Rollback to Previous Deployment

**Option 1: Vercel Dashboard**

1. Vercel Dashboard → Deployments
2. Click "Promote to Production" on previous stable build
3. Confirm rollback

**Option 2: Git Rollback (if needed)**

```bash
# Revert last commit
git revert HEAD

# Or reset to specific commit
git reset --hard <commit-hash>

# Push reverted code
git push origin main

# Vercel will auto-deploy
```

**Option 3: Feature Flag Rollback**

```dart
// Disable problematic feature
const bool ENABLE_NEW_FEATURE = false;

if (ENABLE_NEW_FEATURE) {
  // New code path
} else {
  // Old code path (fallback)
}
```

---

## Security Checklist

### Pre-Deployment

- [ ] Run `flutter analyze` - zero new issues
- [ ] Run `dart format check` - all files formatted
- [ ] Run unit tests - all passing
- [ ] Audit dependencies: `flutter pub outdated`
- [ ] Check for secrets in code - none exposed
- [ ] Update `pubspec.yaml` with stable versions

### API Security

- [ ] API uses HTTPS only
- [ ] JWT tokens have expiry
- [ ] CORS properly configured
- [ ] Rate limiting enabled
- [ ] Input validation on backend
- [ ] SQL injection prevention (parameterized queries)

### Frontend Security

- [ ] No hardcoded secrets in code
- [ ] Environment variables for sensitive data
- [ ] XSS protection headers enabled
- [ ] CSRF tokens in forms
- [ ] Secure password hashing
- [ ] No personal data in logs

### Infrastructure Security

- [ ] HTTPS certificate valid and renewed
- [ ] Security headers set (CSP, X-Frame-Options, etc.)
- [ ] Database credentials secure
- [ ] API keys rotated regularly
- [ ] Backup strategy implemented
- [ ] Access logs monitored

### Post-Deployment

- [ ] Monitor error rates
- [ ] Check API response times
- [ ] Verify offline functionality
- [ ] Test on multiple browsers
- [ ] Monitor database connections
- [ ] Set up alerts for errors

---

## Deployment Checklist

Before each deployment, verify:

```
✓ All tests passing
✓ No console errors
✓ Code analyzed successfully
✓ Dependencies updated
✓ Environment variables set
✓ API endpoints verified
✓ Database backed up
✓ Cache invalidation strategy ready
✓ Monitoring dashboards accessible
✓ Team notified of deployment
✓ Rollback plan documented
✓ Deployment window scheduled
✓ Post-deployment testing plan ready
```

---

## Troubleshooting

### Build Fails on Vercel

```bash
# Solution 1: Clean cache
vercel env pull  # Get env variables
vercel build --yes

# Solution 2: Check logs
vercel logs my-project

# Solution 3: Local verification
flutter clean
flutter pub get
flutter build web --release
```

### Slow Page Load

```dart
// Enable service worker caching
// Enable lazy loading for routes
// Optimize images and assets
// Use compression (Vercel auto-enables)
```

### API Connection Issues

```dart
// Verify env variable: API_BASE_URL
// Check CORS headers on backend
// Verify auth token validity
// Check network connectivity
```

### Offline Mode Not Working

```dart
// Verify LocalCacheService initialized
// Check cache expiry settings
// Verify DatabaseSyncService running
// Monitor connectivity changes
```

---

## Success Criteria

✅ Deployment Successfully Complete When:

1. App accessible at https://yourdomain.com
2. No console errors in production
3. All routes working correctly
4. API calls succeeding
5. Offline mode functioning
6. Performance metrics acceptable
7. Error tracking active
8. Monitoring dashboards showing data
9. Database syncing correctly
10. Team able to access and test

---

## Support & References

- [Vercel Documentation](https://vercel.com/docs)
- [Flutter Web Documentation](https://flutter.dev/docs/get-started/web)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [MySQL Deployment Guide](./DATABASE_SCHEMA.md)
- [API Setup Guide](./BACKEND_API_SETUP.md)

---

**Last Updated**: January 2024
**Version**: 1.0
**Status**: Production Ready ✅
