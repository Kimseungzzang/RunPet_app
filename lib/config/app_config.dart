import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBaseUrl {
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
