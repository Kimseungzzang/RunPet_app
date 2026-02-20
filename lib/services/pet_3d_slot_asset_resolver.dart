import 'package:runpet_app/config/app_config.dart';

class Pet3DSlotAssetResolver {
  static String? resolve({
    required String slot,
    String? itemId,
  }) {
    final template = AppConfig.pet3DSlotModelTemplateUrl.trim();
    if (template.isEmpty) return null;

    final normalizedId = _sanitize(itemId);
    if (normalizedId == 'none') return null;

    return template
        .replaceAll('{slot}', _sanitize(slot))
        .replaceAll('{id}', normalizedId);
  }

  static String _sanitize(String? value) {
    if (value == null || value.isEmpty) return 'none';
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
  }
}
