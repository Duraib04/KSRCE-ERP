# Deployment Guide - Vercel

## Prerequisites
- Flutter SDK installed
- Node.js 18+ installed
- Git repository initialized
- Vercel account (https://vercel.com)

## Local Testing

### 1. Install Flutter Web Dependencies
```bash
flutter pub get
```

### 2. Build Flutter Web
```bash
flutter build web --release
```

### 3. Build outputs will be in:
```
build/web/
```

## Deploy to Vercel

### Option 1: Using Vercel CLI (Recommended)

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel**
   ```bash
   vercel login
   ```

3. **Deploy**
   ```bash
   vercel --prod
   ```

### Option 2: Using GitHub Integration

1. **Push code to GitHub**
   ```bash
   git add .
   git commit -m "Add Vercel deployment configuration"
   git push origin main
   ```

2. **Connect Repository to Vercel**
   - Go to https://vercel.com/new
   - Select "Import Git Repository"
   - Connect your GitHub account
   - Select the KSRCE-ERP repository
   - Click "Deploy"

3. **Configure Build Settings**
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
   - Environment: Ensure Flutter SDK is detected

## Important Notes

### Build Requirements
- Vercel automatically detects Flutter projects
- Ensure `pubspec.yaml` is in the root directory
- The `web/` folder contains Flutter web assets
- `package.json` helps with Node.js configuration

### Troubleshooting

**404 Error After Deployment:**
- Verify `vercel.json` has proper rewrites/redirects
- Check that Flutter web output is being served from `build/web`
- Ensure index.html exists and is properly configured

**Build Fails:**
- Confirm Flutter SDK is installed locally
- Run `flutter clean` and `flutter pub get`
- Check that all dependencies are properly declared in `pubspec.yaml`

### Environment Variables

If you need API endpoints configured by environment:

1. **Set in Vercel Dashboard:**
   - Go to Project Settings → Environment Variables
   - Add `API_BASE_URL` or similar

2. **Use in Code:**
   ```dart
   String apiUrl = String.fromEnvironment('API_BASE_URL', 
     defaultValue: 'http://localhost:8080');
   ```

## Deployment Status

- **Production URL:** https://ksrce-erp.vercel.app
- **Current Status:** Ready for deployment

## Next Steps

1. Ensure all dependencies are installed
2. Test locally with `flutter run -d web-server`
3. Run `flutter build web --release`
4. Deploy using one of the methods above

For more information, visit:
- Flutter Web Documentation: https://flutter.dev/multi-platform/web
- Vercel Documentation: https://vercel.com/docs
