import 'package:PraxisPilot/features/patients/domain/entities/emergency_contact.dart';

/// Data model for emergency contact
class EmergencyContactModel extends EmergencyContact {
  const EmergencyContactModel({
    required super.name,
    required super.phone,
    super.relationship,
  });

  /// Convert from domain entity
  factory EmergencyContactModel.fromEntity(EmergencyContact contact) {
    return EmergencyContactModel(
      name: contact.name,
      phone: contact.phone,
      relationship: contact.relationship,
    );
  }

  /// Convert from JSON
  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: json['relationship'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'relationship': relationship,
    };
  }

  /// Convert to domain entity
  EmergencyContact toEntity() {
    return EmergencyContact(
      name: name,
      phone: phone,
      relationship: relationship,
    );
  }
}