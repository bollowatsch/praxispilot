enum ThemeMode { light, dark, system }

enum DateFormat {
  yMdHyphen,    // YYYY-MM-DD
  dMyDots,      // DD.MM.YYYY
  mDySlash      // MM/DD/YYYY
}

enum TimeFormat { h24, h12 }

enum AppLanguage { de, en }

class UserPreferences {
  final ThemeMode themeMode;
  final DateFormat dateFormat;
  final TimeFormat timeFormat;
  final bool highContrast;
  final bool reduceAnimations;
  final AppLanguage language;
  final String timezone;

  const UserPreferences({
    this.themeMode = ThemeMode.system,
    this.dateFormat = DateFormat.dMyDots,
    this.timeFormat = TimeFormat.h24,
    this.highContrast = false,
    this.reduceAnimations = false,
    this.language = AppLanguage.de,
    this.timezone = 'Europe/Vienna',
  });

  UserPreferences copyWith({
    ThemeMode? themeMode,
    DateFormat? dateFormat,
    TimeFormat? timeFormat,
    bool? highContrast,
    bool? reduceAnimations,
    AppLanguage? language,
    String? timezone,
  }) => UserPreferences(
    themeMode: themeMode ?? this.themeMode,
    dateFormat: dateFormat ?? this.dateFormat,
    timeFormat: timeFormat ?? this.timeFormat,
    highContrast: highContrast ?? this.highContrast,
    reduceAnimations: reduceAnimations ?? this.reduceAnimations,
    language: language ?? this.language,
    timezone: timezone ?? this.timezone,
  );
}
