import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final Icon? icon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;

  const AuthFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.icon,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(labelText: hintText, prefixIcon: icon),
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted != null ? (_) => onFieldSubmitted!() : null,
    );
  }
}
