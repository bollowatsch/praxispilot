import 'package:flutter/material.dart';
import 'package:flutter_app/config/themes/app_theme.dart';
import 'package:flutter_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter_app/shared/widgets/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/auth_form_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authStateProvider.notifier)
        .login(email: _mailController.text, password: _passwordController.text);

    if (success && mounted)
      print('Login Successful');
    else
      print('unsuccessful login: success = ${success}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Login to PraxisPilot',
                    style: context.textTheme.titleLarge,
                  ),
                  SizedBox(height: 30),
                  AuthFormField(
                    hintText: 'Email address',
                    icon: Icon(Icons.mail_outline),
                    controller: _mailController,
                  ),
                  SizedBox(height: 15),
                  AuthFormField(
                    hintText: 'Password',
                    icon: Icon(Icons.password_outlined),
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  SizedBox(height: 30),
                  PrimaryButton(
                    label: 'Login',
                    icon: Icons.login,
                    onPressed: _handleLogin,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: context.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Sign Up here!',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
