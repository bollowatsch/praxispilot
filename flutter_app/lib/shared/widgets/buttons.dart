import 'package:flutter/material.dart';
import 'package:flutter_app/config/themes/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final String? tooltip;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: isFullWidth ? Size(double.infinity, 48) : null,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
              : Row(
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: isFullWidth ? Size(double.infinity, 48) : null,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
              : Row(
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
    );
  }
}

class DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool requireConfirmation;
  final String? confirmationTitle;
  final String? confirmationMessage;

  const DestructiveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.requireConfirmation = true,
    this.confirmationTitle,
    this.confirmationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => _handlePress(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        minimumSize: Size(double.infinity, 48),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onError,
                  ),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
    );
  }

  Future<void> _handlePress(BuildContext context) async {
    if (!requireConfirmation) {
      onPressed?.call();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(confirmationTitle ?? 'Confirmation necessary'),
            content: Text(confirmationMessage ?? 'Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: Text(label),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      onPressed?.call();
    }
  }
}

class IconOnlyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;

  const IconOnlyButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: size * 0.6,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: Size(size, size),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

class FloatingActionButtonExtended extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const FloatingActionButtonExtended({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: isLoading ? null : onPressed,
      icon:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
              : Icon(icon),
      label: Text(label),
    );
  }
}

class ComplianceAwareButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool requiresConsent;
  final bool hasConsent;
  final IconData? icon;
  final String consentMessage;

  const ComplianceAwareButton({
    super.key,
    required this.label,
    this.onPressed,
    this.requiresConsent = false,
    this.hasConsent = true,
    this.icon,
    this.consentMessage = 'This action needs confirmation.',
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !requiresConsent || hasConsent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          label: label,
          icon: icon,
          onPressed: isEnabled ? onPressed : null,
        ),

        if (requiresConsent && !hasConsent) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.error),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  size: 20,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    consentMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
