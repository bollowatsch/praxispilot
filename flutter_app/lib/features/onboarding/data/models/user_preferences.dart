import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart';

class UserPreferencesModel {
  final String themeMode;
  final String language;
  final String timezone;
  final int sessionDuration;

  const UserPreferencesModel({
    required this.themeMode,
    required this.language,
    required this.timezone,
    required this.sessionDuration,
  });

  factory UserPreferencesModel.fromMap({required Map<String, dynamic> map}) {
    return UserPreferencesModel(
      themeMode: map['theme_mode'] as String,
      language: map['language'] as String,
      timezone: map['timezone'] as String,
      sessionDuration: map['session_duration'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toMap() => {
    'theme_mode': themeMode,
    'language': language,
    'timezone': timezone,
    'session_duration': sessionDuration,
  };

  UserPreferences toEntity() {
    return UserPreferences(
      themeMode: _parseThemeMode(themeMode),
      language: _parseLanguage(language),
      timezone: timezone,
      sessionDuration: sessionDuration,
    );
  }

  factory UserPreferencesModel.fromEntity({required UserPreferences entity}) {
    return UserPreferencesModel(
      themeMode: entity.themeMode.name,
      language: entity.language.name,
      timezone: entity.timezone,
      sessionDuration: entity.sessionDuration,
    );
  }

  static ThemeMode _parseThemeMode(String value) {
    switch (value.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static AppLanguage _parseLanguage(String value) {
    switch (value.toLowerCase()) {
      case 'de':
        return AppLanguage.de;
      case 'en':
        return AppLanguage.en;
      default:
        return AppLanguage.de;
    }
  }
}
