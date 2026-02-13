#!/usr/bin/env bash
set -euo pipefail

# CI-friendly flags
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true
export FLUTTER_ALLOW_ROOT=1

# Install Flutter SDK if not available
if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -d "$HOME/flutter" ]; then
    git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$HOME/flutter"
  fi
  export PATH="$HOME/flutter/bin:$PATH"
fi

flutter --version

# Ensure web support and no analytics prompts
flutter config --no-analytics >/dev/null 2>&1 || true
flutter config --enable-web >/dev/null 2>&1 || true

# Dependencies
flutter pub get

# Build with environment-driven dart-defines
sanitize() {
  printf '%s' "$1" | tr -d '\r' | tr -d '\n'
}

API_BASE_URL="$(sanitize "${API_BASE_URL:-http://localhost:3000}")"
FLUTTER_ENV="$(sanitize "${FLUTTER_ENV:-production}")"
API_TIMEOUT="$(sanitize "${API_TIMEOUT:-30000}")"
ENABLE_OFFLINE_MODE="$(sanitize "${ENABLE_OFFLINE_MODE:-true}")"
ENABLE_BACKGROUND_SYNC="$(sanitize "${ENABLE_BACKGROUND_SYNC:-true}")"
CACHE_EXPIRY_HOURS="$(sanitize "${CACHE_EXPIRY_HOURS:-24}")"

flutter build web --release \
  --dart-define=API_BASE_URL="$API_BASE_URL" \
  --dart-define=FLUTTER_ENV="$FLUTTER_ENV" \
  --dart-define=API_TIMEOUT="$API_TIMEOUT" \
  --dart-define=ENABLE_OFFLINE_MODE="$ENABLE_OFFLINE_MODE" \
  --dart-define=ENABLE_BACKGROUND_SYNC="$ENABLE_BACKGROUND_SYNC" \
  --dart-define=CACHE_EXPIRY_HOURS="$CACHE_EXPIRY_HOURS"
