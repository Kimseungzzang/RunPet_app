$ErrorActionPreference = "Stop"

# Optional: set API_BASE_URL to force a specific endpoint in release mode.
# Example:
# $env:API_BASE_URL="https://api.example.com"

flutter pub get
if ($env:API_BASE_URL) {
  flutter run --release --dart-define=APP_ENV=release --dart-define=API_BASE_URL=$env:API_BASE_URL
} else {
  flutter run --release --dart-define=APP_ENV=release
}

