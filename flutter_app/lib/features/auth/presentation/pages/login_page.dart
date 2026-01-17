import 'package:PraxisPilot/config/themes/app_theme.dart';
import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:PraxisPilot/shared/widgets/buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  late TapGestureRecognizer _onTapRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _onTapRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            context.goNamed('signup');
            return;
          };
    super.initState();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authStateProvider.notifier)
        .login(email: _mailController.text, password: _passwordController.text);

    if (success && mounted) {
      context.goNamed('dashboard');
    } else {
      debugPrint('unsuccessful login: success = $success');
    }
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
                    context.l10n.login_welcomeText,
                    style: context.textTheme.titleLarge,
                  ),
                  SizedBox(height: 30),
                  AuthFormField(
                    hintText: context.l10n.login_email,
                    icon: Icon(Icons.mail_outline),
                    controller: _mailController,
                  ),
                  SizedBox(height: 15),
                  AuthFormField(
                    hintText: context.l10n.login_password,
                    icon: Icon(Icons.lock_outline),
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  SizedBox(height: 30),
                  PrimaryButton(
                    label: context.l10n.login_login,
                    icon: Icons.login,
                    onPressed: _handleLogin,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: context.l10n.login_noAccount,
                style: context.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: context.l10n.login_signUpHere,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                    recognizer: _onTapRecognizer,
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
