import 'package:flutter/foundation.dart';

class AppConfig {
  static const String env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const String _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const bool enable3DPet = bool.fromEnvironment('ENABLE_3D_PET', defaultValue: false);
  static const String pet3DModelUrl = String.fromEnvironment(
    'PET_3D_MODEL_URL',
    defaultValue: 'https://modelviewer.dev/shared-assets/models/Fox.glb',
  );

  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) return _apiBaseUrlOverride;

    if (env == 'release') {
      // Replace this with your production API domain when deployed.
      return 'http://localhost:8080';
    }

    if (kIsWeb) return 'http://localhost:8080';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8080';
      default:
        return 'http://localhost:8080';
    }
  }

  static const Set<String> iapProductIds = {
    'no_ads_monthly',
    'coin_pack_starter',
    'costume_pack_a',
  };
}
