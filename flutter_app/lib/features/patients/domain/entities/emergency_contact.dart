/// Emergency contact information for a patient
class EmergencyContact {
  final String name;
  final String phone;
  final String? relationship;

  const EmergencyContact({
    required this.name,
    required this.phone,
    this.relationship,
  });

  EmergencyContact copyWith({
    String? name,
    String? phone,
    String? relationship,
  }) {
    return EmergencyContact(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
    );
  }
}