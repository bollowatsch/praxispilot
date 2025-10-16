import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/themes/app_theme.dart';
import 'package:flutter_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter_app/features/auth/presentation/widgets/form_validators.dart';
import 'package:flutter_app/shared/widgets/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/auth_form_field.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<SignUpPage> {
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
            print(
              'Should navigate to /login',
            ); // TODO goRouter navigate to /login
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
                    'Sign into PraxisPilot',
                    style: context.textTheme.titleLarge,
                  ),
                  SizedBox(height: 30),
                  AuthFormField(
                    hintText: 'Email address',
                    icon: Icon(Icons.mail_outline),
                    controller: _mailController,
                    validator: mailValidator,
                  ),
                  SizedBox(height: 15),
                  AuthFormField(
                    hintText: 'Password',
                    icon: Icon(Icons.lock_outline),
                    isPassword: true,
                    controller: _passwordController,
                    validator: passwordValidator,
                  ),
                  SizedBox(height: 15),
                  AuthFormField(
                    hintText: 'Confirm password',
                    icon: Icon(Icons.lock_outline),
                    isPassword: true,
                    controller: _confirmPasswordController,
                    validator:
                        (value) =>
                            _passwordController.text != value
                                ? 'Passwords do not match'
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
                text: 'Already have an account? ',
                style: context.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Log in here!',
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
