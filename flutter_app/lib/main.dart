import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/praxispilot.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  if (kDebugMode) {
    SupabaseConfig.printConfiguration();
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const ProviderScope(child: PraxisPilot()));
}
