import 'package:PraxisPilot/config/themes/app_theme.dart';
import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart'
    as prefs;
import 'package:PraxisPilot/features/onboarding/presentation/providers/user_preferences_provider.dart';
import 'package:PraxisPilot/features/onboarding/presentation/widgets/widgets.dart';
import 'package:PraxisPilot/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingPreferencesPage extends ConsumerStatefulWidget {
  const OnboardingPreferencesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingPreferencesPageState();
}

class _OnboardingPreferencesPageState
    extends ConsumerState<OnboardingPreferencesPage> {
  final _formKey = GlobalKey<FormState>();

  prefs.ThemeMode _themeMode = prefs.ThemeMode.system;
  prefs.DateFormat _dateFormat = prefs.DateFormat.dMyDots;
  prefs.TimeFormat _timeFormat = prefs.TimeFormat.h24;
  String _timezone = 'Europe/Vienna';
  prefs.AppLanguage _language = prefs.AppLanguage.de;
  bool _highContrast = false;
  bool _reduceAnimations = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.l10n.preferences_title,
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: ThemeModeSelector(
                          value: _themeMode,
                          onChanged: (mode) {
                            setState(() => _themeMode = mode);
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<prefs.DateFormat>(
                          value: _dateFormat,
                          decoration: InputDecoration(
                            labelText: context.l10n.preferences_dateFormat,
                          ),
                          items:
                              prefs.DateFormat.values.map((fmt) {
                                return DropdownMenuItem(
                                  value: fmt,
                                  child: Text(fmt.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _dateFormat = value);
                          },
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// TimeFormat + Locale
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<prefs.TimeFormat>(
                          value: _timeFormat,
                          decoration: InputDecoration(
                            labelText: context.l10n.preferences_timeFormat,
                          ),
                          items:
                              prefs.TimeFormat.values.map((fmt) {
                                return DropdownMenuItem(
                                  value: fmt,
                                  child: Text(fmt.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _timeFormat = value);
                          },
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<prefs.AppLanguage>(
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _language = value);
                          },
                          validator: (value) {
                            // Falls später notwendig – jetzt einfach immer OK
                            return null;
                          },
                          value: _language,
                          decoration: InputDecoration(
                            labelText: context.l10n.preferences_language,
                          ),
                          items:
                              prefs.AppLanguage.values.map((lang) {
                                return DropdownMenuItem(
                                  value: lang,
                                  child: Text(switch (lang) {
                                    prefs.AppLanguage.de => 'Deutsch',
                                    prefs.AppLanguage.en => 'English',
                                  }),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Switches: High Contrast + Reduce Animations
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          title: Text(context.l10n.preferences_highContrast),
                          value: _highContrast,
                          onChanged: (val) {
                            setState(() => _highContrast = val);
                          },
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          title: Text(
                            context.l10n.preferences_reduceAnimations,
                          ),
                          value: _reduceAnimations,
                          onChanged: (val) {
                            setState(() => _reduceAnimations = val);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Timezone
                  DropdownButtonFormField<String>(
                    value: _timezone,
                    decoration: InputDecoration(
                      labelText: context.l10n.preferences_timezone,
                    ),
                    items:
                        const [
                          "Europe/Vienna",
                          "Europe/Berlin",
                          "UTC",
                          "America/New_York",
                          "Asia/Tokyo",
                        ].map((tz) {
                          return DropdownMenuItem(value: tz, child: Text(tz));
                        }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _timezone = value);
                    },
                    validator: (value) {
                      // Beispiel: Timezone muss gesetzt sein
                      if (value == null || value.isEmpty) {
                        return context.l10n.form_error_required;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: PrimaryButton(
                        label: '',
                        icon: Icons.arrow_back,
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Flexible(
                      child: PrimaryButton(
                        label: '',
                        icon: Icons.check,
                        onPressed: _handleSubmit,
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final userPreferences = prefs.UserPreferences(
      themeMode: _themeMode,
      dateFormat: _dateFormat,
      timeFormat: _timeFormat,
      highContrast: _highContrast,
      reduceAnimations: _reduceAnimations,
      language: _language,
      timezone: _timezone,
    );

    final result = await ref
        .read(setUserPreferencesProvider)
        .call(userPreferences: userPreferences);

    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${failure.message}'),
            backgroundColor: context.colorScheme.error,
          ),
        );
      },
      (_) {
        // Onboarding complete, navigate to home
        context.goNamed('home');
      },
    );
  }
}
