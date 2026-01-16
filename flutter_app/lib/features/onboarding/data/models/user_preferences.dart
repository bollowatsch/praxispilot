import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart';

class UserPreferencesModel {
  final String themeMode;
  final String dateFormat;
  final String timeFormat;
  final bool highContrast;
  final bool reduceAnimations;
  final String language;
  final String timezone;

  const UserPreferencesModel({
    required this.themeMode,
    required this.dateFormat,
    required this.timeFormat,
    required this.highContrast,
    required this.reduceAnimations,
    required this.language,
    required this.timezone,
  });

  factory UserPreferencesModel.fromMap({required Map<String, dynamic> map}) {
    return UserPreferencesModel(
      themeMode: map['theme_mode'] as String,
      dateFormat: map['date_format'] as String,
      timeFormat: map['time_format'] as String,
      highContrast: map['high_contrast'] as bool,
      reduceAnimations: map['reduce_animations'] as bool,
      language: map['language'] as String,
      timezone: map['timezone'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'theme_mode': themeMode,
    'date_format': dateFormat,
    'time_format': timeFormat,
    'high_contrast': highContrast,
    'reduce_animations': reduceAnimations,
    'language': language,
    'timezone': timezone,
  };

  UserPreferences toEntity() {
    return UserPreferences(
      themeMode: _parseThemeMode(themeMode),
      dateFormat: _parseDateFormat(dateFormat),
      timeFormat: _parseTimeFormat(timeFormat),
      highContrast: highContrast,
      reduceAnimations: reduceAnimations,
      language: _parseLanguage(language),
      timezone: timezone,
    );
  }

  factory UserPreferencesModel.fromEntity({required UserPreferences entity}) {
    return UserPreferencesModel(
      themeMode: entity.themeMode.name,
      dateFormat: entity.dateFormat.name,
      timeFormat: entity.timeFormat.name,
      highContrast: entity.highContrast,
      reduceAnimations: entity.reduceAnimations,
      language: entity.language.name,
      timezone: entity.timezone,
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

  static DateFormat _parseDateFormat(String value) {
    switch (value.toLowerCase()) {
      case 'yMdHyphen':
        return DateFormat.yMdHyphen;
      case 'dMyDots':
        return DateFormat.dMyDots;
      case 'mDySlash':
        return DateFormat.mDySlash;
      default:
        return DateFormat.dMyDots;
    }
  }

  static TimeFormat _parseTimeFormat(String value) {
    switch (value.toLowerCase()) {
      case 'h24':
        return TimeFormat.h24;
      case 'h12':
        return TimeFormat.h12;
      default:
        return TimeFormat.h24;
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
