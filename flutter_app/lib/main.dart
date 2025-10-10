import 'package:flutter/material.dart';
import 'package:flutter_app/config/themes/app_theme.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_page.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PraxisPilot',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
