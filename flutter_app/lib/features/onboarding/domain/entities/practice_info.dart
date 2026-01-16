class PracticeInfo {
  final String practiceName;
  final String practiceType;
  final String street;
  final String houseNumber;
  final String postalCode;
  final String city;
  final String state;
  final String country;
  final String phone;
  final String email;
  final String website;

  const PracticeInfo({
    required this.practiceName,
    required this.practiceType,
    required this.street,
    required this.houseNumber,
    required this.postalCode,
    required this.city,
    required this.state,
    required this.country,
    required this.phone,
    required this.email,
    required this.website,
  });

  PracticeInfo copyWith({
    String? practiceName,
    String? practiceType,
    String? street,
    String? houseNumber,
    String? postalCode,
    String? city,
    String? state,
    String? country,
    String? phone,
    String? email,
    String? website,
  }) => PracticeInfo(
    practiceName: practiceName ?? this.practiceName,
    practiceType: practiceType ?? this.practiceType,
    street: street ?? this.street,
    houseNumber: houseNumber ?? this.houseNumber,
    postalCode: postalCode ?? this.postalCode,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    website: website ?? this.website,
  );
}