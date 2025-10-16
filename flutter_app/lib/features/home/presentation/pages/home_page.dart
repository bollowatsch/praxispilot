import 'package:flutter/material.dart';
import 'package:flutter_app/shared/widgets/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              label: 'Go to login',
              onPressed: () => context.goNamed('login'),
            ),
            SizedBox(height: 30),
            PrimaryButton(
              label: 'Go to Signup',
              onPressed: () => context.goNamed('signup'),
            ),
          ],
        ),
      ),
    );
  }
}
