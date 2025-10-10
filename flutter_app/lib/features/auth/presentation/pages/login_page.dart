import 'package:flutter/material.dart';
import 'package:flutter_app/shared/widgets/buttons.dart';

import '../widgets/auth_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthFormField(hintText: 'Email address'),
            SizedBox(height: 10),
            AuthFormField(hintText: 'Name'),
            SizedBox(height: 10),
            AuthFormField(hintText: 'Password', isObscure: true),
            SizedBox(height: 10),
            AuthFormField(hintText: 'Confirm Password', isObscure: true),
            SizedBox(height: 15),
            PrimaryButton(label: 'Login', icon: Icons.login),
          ],
        ),
      ),
    );
  }
}
