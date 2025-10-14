class User {
  final String id;
  final String email;
  final DateTime createdAt;
  // final String firstname;
  // final String lastname;

  const User({
    required this.id,
    required this.email,
    required this.createdAt,
    // required this.firstname,
    // required this.lastname,
  });

  // String get displayName => '$firstname $lastname';
}
