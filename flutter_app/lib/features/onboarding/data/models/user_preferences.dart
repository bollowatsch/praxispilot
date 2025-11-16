import 'dart:ui';

import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart';

class UserPreferencesModel {
  final String themeMode;
  final String dateFormat;
  final String timeFormat;
  final bool highContrast;
  final bool reduceAnimations;
  final String locale;
  final String timezone;

  const UserPreferencesModel({
    required this.themeMode,
    required this.dateFormat,
    required this.timeFormat,
    required this.highContrast,
    required this.reduceAnimations,
    required this.locale,
    required this.timezone,
  });

  factory UserPreferencesModel.fromMap({required Map<String, dynamic> map}) {
    return UserPreferencesModel(
      themeMode: map['theme_mode'] as String,
      dateFormat: map['date_format'] as String,
      timeFormat: map['time_format'] as String,
      highContrast: map['high_contrast'] as bool,
      reduceAnimations: map['reduce_animations'] as bool,
      locale: map['language'] as String,
      timezone: map['timezone'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'theme_mode': themeMode,
    'date_format': dateFormat,
    'time_format': timeFormat,
    'high_contrast': highContrast,
    'reduce_animations': reduceAnimations,
    'language': locale,
    'timezone': timezone,
  };

  UserPreferences toEntity() {
    return UserPreferences(
      themeMode: ThemeMode.values.asNameMap()['theme_mode'] ?? ThemeMode.system,
      dateFormat:
          DateFormat.values.asNameMap()['date_format'] ?? DateFormat.dMyDots,
      timeFormat:
          TimeFormat.values.asNameMap()['time_format'] ?? TimeFormat.h24,
      highContrast: highContrast,
      reduceAnimations: reduceAnimations,
      locale: Locale(locale),
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
      locale: entity.locale.languageCode,
      timezone: entity.timezone,
    );
  }
}
