import 'dart:async';

import 'package:flutter/foundation.dart';

/// Service that tracks user inactivity and triggers logout after 30 minutes
class InactivityService {
  static const Duration _inactivityTimeout = Duration(minutes: 30);

  Timer? _inactivityTimer;
  final VoidCallback onInactivityTimeout;

  InactivityService({required this.onInactivityTimeout});

  void resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityTimeout, () {
      debugPrint('User inactive for 30 minutes, triggering logout');
      onInactivityTimeout();
    });
  }

  void stopTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  void dispose() {
    stopTimer();
  }
}
