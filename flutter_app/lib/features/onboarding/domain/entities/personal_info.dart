class PersonalInfo {
  final String titlePrefix;
  final String firstName;
  final String lastName;
  final String titleSuffix;
  final String email;
  final String phone;

  const PersonalInfo({
    required this.titlePrefix,
    required this.firstName,
    required this.lastName,
    required this.titleSuffix,
    required this.email,
    required this.phone,
  });

  PersonalInfo copyWith({
    String? titlePrefix,
    String? firstName,
    String? lastName,
    String? titleSuffix,
    String? email,
    String? phone,
  }) => PersonalInfo(
    titlePrefix: titlePrefix ?? this.titlePrefix,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    titleSuffix: titleSuffix ?? this.titleSuffix,
    email: email ?? this.email,
    phone: phone ?? this.phone,
  );
}