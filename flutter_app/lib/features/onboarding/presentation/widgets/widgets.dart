import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart'
    as prefs;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  /// aktuell ausgewählter ThemeMode
  final prefs.ThemeMode value;

  /// Callback, wenn der Nutzer einen Tile auswählt
  final ValueChanged<prefs.ThemeMode> onChanged;

  /// Optionaler Label-Text über den Tiles (z.B. "Theme")
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: _ThemeModeTile(
                icon: Icons.light_mode_outlined,
                label: 'Hell',
                selected: value == prefs.ThemeMode.light,
                onTap: () => onChanged(prefs.ThemeMode.light),
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ThemeModeTile(
                icon: Icons.dark_mode_outlined,
                label: 'Dunkel',
                selected: value == ThemeMode.dark,
                onTap: () => onChanged(prefs.ThemeMode.dark),
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ThemeModeTile(
                icon: Icons.brightness_auto_outlined,
                label: 'System',
                selected: value == ThemeMode.system,
                onTap: () => onChanged(prefs.ThemeMode.system),
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemeModeTile extends ConsumerWidget {
  const _ThemeModeTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor =
        selected ? colorScheme.primary.withOpacity(0.1) : colorScheme.surface;
    final borderColor =
        selected ? colorScheme.primary : colorScheme.outlineVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? colorScheme.primary : colorScheme.onSurface,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
