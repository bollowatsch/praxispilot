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
  String _timezone = 'Europe/Vienna';
  prefs.AppLanguage _language = prefs.AppLanguage.de;
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
                  /// Theme Mode
                  ThemeModeSelector(
                    value: _themeMode,
                    onChanged: (mode) {
                      setState(() => _themeMode = mode);
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Language + Timezone
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<prefs.AppLanguage>(
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _language = value);
                          },
                          validator: (value) {
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
        // Onboarding complete, navigate to dashboard
        context.goNamed('dashboard');
      },
    );
  }
}
