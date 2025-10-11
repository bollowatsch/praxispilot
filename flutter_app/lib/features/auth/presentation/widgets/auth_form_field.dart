import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final Icon? icon;
  const AuthFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(labelText: hintText, prefixIcon: icon),
      controller: controller,
    );
  }
}
