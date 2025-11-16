import 'package:PraxisPilot/config/themes/app_theme.dart';
import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:PraxisPilot/features/auth/presentation/widgets/form_validators.dart';
import 'package:PraxisPilot/shared/widgets/buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_form_field.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late TapGestureRecognizer _onTapRecognizer;

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _onTapRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            context.goNamed('login');
            return;
          };
    super.initState();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authStateProvider.notifier)
        .signup(
          email: _mailController.text,
          password: _passwordController.text,
        );

    if (success && mounted)
      print('SignUp Successful');
    else
      print('unsuccessful signup!');
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
                    context.l10n.signup_title,
                    style: context.textTheme.titleLarge,
                  ),
                  SizedBox(height: 30),
                  AuthFormField(
                    hintText: context.l10n.login_email,
                    icon: Icon(Icons.mail_outline),
                    controller: _mailController,
                    validator: mailValidator,
                  ),
                  SizedBox(height: 15),
                  AuthFormField(
                    hintText: context.l10n.login_password,
                    icon: Icon(Icons.lock_outline),
                    isPassword: true,
                    controller: _passwordController,
                    validator: passwordValidator,
                  ),
                  SizedBox(height: 15),
                  AuthFormField(
                    hintText: context.l10n.signup_confirmPassword,
                    icon: Icon(Icons.lock_outline),
                    isPassword: true,
                    controller: _confirmPasswordController,
                    validator:
                        (value) =>
                            _passwordController.text != value
                                ? context.l10n.signup_noMatch
                                : null,
                  ),
                  SizedBox(height: 30),
                  PrimaryButton(
                    label: 'Login',
                    icon: Icons.login,
                    onPressed: _handleSignup,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: context.l10n.signup_accountPresent,
                style: context.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: context.l10n.signup_loginHere,
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
