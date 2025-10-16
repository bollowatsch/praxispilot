import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final Icon? icon;
  final String? Function(String?)? validator;
  const AuthFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(labelText: hintText, prefixIcon: icon),
      controller: controller,
      validator: validator,
    );
  }
}
