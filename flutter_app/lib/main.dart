import 'package:flutter/material.dart';
import 'package:flutter_app/config/themes/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/app_entry_point.dart';

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO Initialize Supabase
  // TODO Initialize dependency injection

  runApp(const PraxisPilot());
}

class PraxisPilot extends StatelessWidget {
  const PraxisPilot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global providers
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Praxis Management System',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,

            // WICHTIG: Nutze einen Router für intelligentes Routing
            home: const AppEntryPoint(),

            // Oder mit GoRouter (empfohlen)
            // router: appRouter,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('de', 'DE'), // Deutsch (primär)
              Locale('en', 'US'), // Englisch (sekundär)
            ],
          );
        },
      ),
    );
  }
}
