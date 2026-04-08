import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) {
      return _baseUrlOverride;
    }

    if (kIsWeb) {
      return 'http://localhost/bicycles';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/bicycles';
    }

    return 'http://localhost/bicycles';
  }
}
