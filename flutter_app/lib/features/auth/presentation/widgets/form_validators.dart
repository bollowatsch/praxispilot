String? mailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is mandatory';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please provide a valid email-address';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is mandatory';
  }
  if (value.length < 8) {
    return 'Password needs to have at least 8 characters';
  }
  if (!RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  ).hasMatch(value)) {
    return 'Invalid password';
  }
  return null;
}
