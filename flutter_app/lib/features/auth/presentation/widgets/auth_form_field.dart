import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String hintText;
  final bool isObscure;
  const AuthFormField({
    super.key,
    required this.hintText,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(labelText: hintText),
    );
  }
}
