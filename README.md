# RunPet App

## Run
```powershell
flutter pub get
flutter run
```

## Mode Run (local)
### Dev mode
```powershell
.\scripts\run_dev.ps1
```

### Release mode
```powershell
.\scripts\run_release.ps1
```

### Release mode with custom API URL
```powershell
$env:API_BASE_URL="https://api.example.com"
.\scripts\run_release.ps1
```

## API base URL
- Android emulator: `http://10.0.2.2:8080`
- iOS/desktop/web: `http://localhost:8080`

Configured in `lib/config/app_config.dart`.

## In-app purchase
- Product IDs are configured in `lib/config/app_config.dart`.
- Purchase flow:
  1. query product details
  2. request purchase (`in_app_purchase`)
  3. receive purchase stream event
  4. verify on backend (`/api/v1/payments/verify`)

Note: real store verification requires backend env credentials.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
