enum Environment { local, development, staging, production }

class EnvironmentConfig {
  static const String _currentEnvironment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'local',
  );

  static Environment get environment {
    switch (_currentEnvironment.toLowerCase()) {
      case 'local':
        return Environment.local;
      case 'development':
        return Environment.development;
      case 'staging':
        return Environment.staging;
      case 'production':
        return Environment.production;
      default:
        return Environment.local;
    }
  }

  static bool get isLocal => environment == Environment.local;
  static bool get isDevelopment => environment == Environment.development;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProduction => environment == Environment.production;
}
