import 'package:runpet_app/config/app_config.dart';

class Pet3DModelResolver {
  static String resolve({
    String? hatId,
    String? outfitId,
    String? bgId,
  }) {
    final template = AppConfig.pet3DModelTemplateUrl.trim();
    if (template.isEmpty) {
      return AppConfig.pet3DModelUrl;
    }

    return template
        .replaceAll('{hat}', _sanitize(hatId))
        .replaceAll('{outfit}', _sanitize(outfitId))
        .replaceAll('{bg}', _sanitize(bgId));
  }

  static String _sanitize(String? value) {
    if (value == null || value.isEmpty) return 'none';
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
  }
}
