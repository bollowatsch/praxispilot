enum ThemeMode { light, dark, system }

enum AppLanguage { de, en }

class UserPreferences {
  final ThemeMode themeMode;
  final AppLanguage language;
  final String timezone;

  const UserPreferences({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.de,
    this.timezone = 'Europe/Vienna',
  });

  UserPreferences copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    String? timezone,
  }) => UserPreferences(
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
    timezone: timezone ?? this.timezone,
  );
}
