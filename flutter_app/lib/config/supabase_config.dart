import 'package:flutter_app/config/environment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static final String _localUrl = dotenv.env['SUPABASE_URL_LOCAL']!;
  static final String _localKey = dotenv.env['SUPABASE_ANONKEY_LOCAL']!;

  static final String _developmentUrl = dotenv.env['SUPABASE_URL_DEVELOPMENT']!;
  static final String _developmentKey =
      dotenv.env['SUPABASE_ANONKEY_DEVELOPMENT']!;

  static final String _stagingUrl = dotenv.env['SUPABASE_URL_STAGING']!;
  static final String _stagingKey = dotenv.env['SUPABASE_ANONKEY_STAGING']!;

  static final String _productionUrl = dotenv.env['SUPABASE_URL_PRODUCTION']!;
  static final String _productionKey =
      dotenv.env['SUPABASE_ANONKEY_PRODUCTION']!;

  static String get url {
    switch (EnvironmentConfig.environment) {
      case Environment.local:
        return _localUrl;
      case Environment.development:
        return _developmentUrl;
      case Environment.staging:
        return _stagingUrl;
      case Environment.production:
        return _productionUrl;
    }
  }

  static String get anonKey {
    switch (EnvironmentConfig.environment) {
      case Environment.local:
        return _localKey;
      case Environment.development:
        return _developmentKey;
      case Environment.staging:
        return _stagingKey;
      case Environment.production:
        return _productionKey;
    }
  }

  static void printConfiguration() {
    print('''
╔════════════════════════════════════════════════════╗
║           SUPABASE CONFIGURATION                   ║
╠════════════════════════════════════════════════════╣
║ Environment: ${EnvironmentConfig.environment.name.padRight(38)}║
║ API URL: ${url.padRight(43).substring(0, 43)}║
╚════════════════════════════════════════════════════╝
    ''');
  }
}
