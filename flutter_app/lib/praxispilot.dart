import 'package:flutter/material.dart';
import 'package:flutter_app/config/routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/themes/app_theme.dart';

class PraxisPilot extends ConsumerWidget {
  const PraxisPilot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PraxisPilot',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
