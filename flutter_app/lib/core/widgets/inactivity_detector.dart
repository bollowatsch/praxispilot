import 'package:PraxisPilot/config/routes/app_router.dart';
import 'package:PraxisPilot/core/services/inactivity_service.dart';
import 'package:PraxisPilot/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that detects user activity and triggers automatic logout after 30 minutes of inactivity
class InactivityDetector extends ConsumerStatefulWidget {
  final Widget child;

  const InactivityDetector({required this.child, super.key});

  @override
  ConsumerState<InactivityDetector> createState() => _InactivityDetectorState();
}

class _InactivityDetectorState extends ConsumerState<InactivityDetector> {
  InactivityService? _service;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() {
    _service = InactivityService(onInactivityTimeout: _handleInactivityTimeout);
    // Don't start timer immediately - wait until user is logged in
  }

  Future<void> _handleInactivityTimeout() async {
    if (!mounted) return;

    // Check if user is actually signed in before attempting logout
    final currentUser = ref.read(authStateProvider).currentUser;
    if (currentUser == null) {
      return;
    }

    await ref.read(authStateProvider.notifier).logout();

    if (!mounted) return;

    appRouter.goNamed('login');

    // Wait briefly to ensure navigation completes before showing snackbar
    await Future.delayed(const Duration(milliseconds: 500));

    // Get context from router's navigator key (not from widget tree)
    final navContext = appRouter.routerDelegate.navigatorKey.currentContext;
    if (navContext != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(navContext).showSnackBar(
        const SnackBar(
          content: Text(
            'Sie wurden aufgrund von Inaktivität automatisch abgemeldet.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _onUserActivity() {
    _service?.resetTimer();
  }

  @override
  void dispose() {
    _service?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state to stop timer when logged out
    ref.listen(authStateProvider, (previous, next) {
      if (next.currentUser == null) {
        // User is logged out, stop the timer
        _service?.stopTimer();
      } else if (previous?.currentUser == null && next.currentUser != null) {
        // User just logged in, start the timer
        _service?.resetTimer();
      }
    });

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _onUserActivity(),
      onPointerMove: (_) => _onUserActivity(),
      onPointerUp: (_) => _onUserActivity(),
      child: widget.child,
    );
  }
}
