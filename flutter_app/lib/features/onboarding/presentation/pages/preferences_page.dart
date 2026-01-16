import 'package:PraxisPilot/config/themes/app_theme.dart';
import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart'
    as prefs;
import 'package:PraxisPilot/features/onboarding/presentation/providers/user_preferences_provider.dart';
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
  int _sessionDuration = 50; // in minutes: 45, 50, or 60
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Onboarding'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressIndicator(context),
                    const SizedBox(height: 32),
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildThemeModeSection(context, primary),
                          const SizedBox(height: 24),
                          _buildLanguageSection(context, colorScheme),
                          const SizedBox(height: 16),
                          _buildSessionDurationSection(
                            context,
                            primary,
                            colorScheme,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoBox(context, primary),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, primary),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FAST GESCHAFFT!',
              style: theme.textTheme.labelSmall?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Schritt 3 von 3',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: 1.0,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(primary),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'Einstellungen',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Passen Sie PraxisPilot an Ihre persönliche Arbeitsweise an.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeModeSection(BuildContext context, Color primary) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'DESIGN-MODUS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildThemeModeCard(
                context,
                icon: Icons.light_mode,
                label: 'Hell',
                mode: prefs.ThemeMode.light,
                isSelected:
                    _themeMode ==
                    prefs
                        .ThemeMode
                        .light, // TODO provider funktioniert nciht nach anklickej
                primary: primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildThemeModeCard(
                context,
                icon: Icons.dark_mode,
                label: 'Dunkel',
                mode: prefs.ThemeMode.dark,
                isSelected: _themeMode == prefs.ThemeMode.dark,
                primary: primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildThemeModeCard(
                context,
                icon: Icons.settings_brightness,
                label: 'System',
                mode: prefs.ThemeMode.system,
                isSelected: _themeMode == prefs.ThemeMode.system,
                primary: primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeModeCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required prefs.ThemeMode mode,
    required bool isSelected,
    required Color primary,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => setState(() => _themeMode = mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isSelected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SPRACHE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<prefs.AppLanguage>(
            value: _language,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
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
            onChanged: (value) {
              if (value != null) {
                setState(() => _language = value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDurationSection(
    BuildContext context,
    Color primary,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SITZUNGSDAUER',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildDurationButton(context, '45 min', 45, primary),
                ),
                Expanded(
                  child: _buildDurationButton(context, '50 min', 50, primary),
                ),
                Expanded(
                  child: _buildDurationButton(context, '60 min', 60, primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationButton(
    BuildContext context,
    String label,
    int duration,
    Color primary,
  ) {
    final theme = Theme.of(context);
    final isSelected = _sessionDuration == duration;

    return InkWell(
      onTap: () => setState(() => _sessionDuration = duration),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color:
                isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, Color primary) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Zeit- und Datumsformate werden automatisch von Ihren Systemeinstellungen übernommen.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, Color primary) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor.withValues(alpha: 0),
            theme.scaffoldBackgroundColor,
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => context.pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: const Text('Zurück'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.check_circle),
                label: const Text('Fertigstellen'),
              ),
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
      sessionDuration: _sessionDuration,
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
