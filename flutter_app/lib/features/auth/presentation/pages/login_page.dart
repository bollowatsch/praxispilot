import 'package:flutter/material.dart';
import 'package:flutter_app/config/themes/app_theme.dart';
import 'package:flutter_app/shared/widgets/buttons.dart';

import '../widgets/auth_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login to PraxisPilot', style: context.textTheme.titleLarge),
            SizedBox(height: 30),
            AuthFormField(
              hintText: 'Email address',
              icon: Icon(Icons.mail_outline),
              controller: mailController,
            ),
            SizedBox(height: 15),
            AuthFormField(
              hintText: 'Password',
              icon: Icon(Icons.password_outlined),
              isPassword: true,
              controller: passwordController,
            ),
            SizedBox(height: 30),
            PrimaryButton(label: 'Login', icon: Icons.login, onPressed: () {}),
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
