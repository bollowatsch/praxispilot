enum ThemeMode { light, dark, system }

enum AppLanguage { de, en }

class UserPreferences {
  final ThemeMode themeMode;
  final AppLanguage language;
  final String timezone;
  final int sessionDuration; // in minutes: 45, 50, or 60

  const UserPreferences({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.de,
    this.timezone = 'Europe/Vienna',
    this.sessionDuration = 50,
  });

  UserPreferences copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    String? timezone,
    int? sessionDuration,
  }) => UserPreferences(
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
    timezone: timezone ?? this.timezone,
    sessionDuration: sessionDuration ?? this.sessionDuration,
  );
}
