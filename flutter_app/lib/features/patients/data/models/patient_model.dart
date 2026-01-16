import 'package:PraxisPilot/features/patients/data/models/emergency_contact_model.dart';
import 'package:PraxisPilot/features/patients/domain/entities/emergency_contact.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';

/// Data model for Patient
class PatientModel extends Patient {
  const PatientModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    super.email,
    super.phone,
    super.address,
    super.insuranceInfo,
    super.emergencyContact,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.archivedAt,
  });

  /// Convert from domain entity
  factory PatientModel.fromEntity(Patient patient) {
    return PatientModel(
      id: patient.id,
      firstName: patient.firstName,
      lastName: patient.lastName,
      dateOfBirth: patient.dateOfBirth,
      email: patient.email,
      phone: patient.phone,
      address: patient.address,
      insuranceInfo: patient.insuranceInfo,
      emergencyContact: patient.emergencyContact,
      status: patient.status,
      createdAt: patient.createdAt,
      updatedAt: patient.updatedAt,
      archivedAt: patient.archivedAt,
    );
  }

  /// Convert from JSON (Supabase response)
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    EmergencyContact? emergencyContact;

    // Check if emergency contact fields exist and are not null
    if (json['emergency_contact_name'] != null &&
        json['emergency_contact_phone'] != null) {
      emergencyContact = EmergencyContactModel(
        name: json['emergency_contact_name'] as String,
        phone: json['emergency_contact_phone'] as String,
        relationship: json['emergency_contact_relationship'] as String?,
      );
    }

    return PatientModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      insuranceInfo: json['insurance_info'] as String?,
      emergencyContact: emergencyContact,
      status: PatientStatus.fromJson(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      archivedAt: json['archived_at'] != null
          ? DateTime.parse(json['archived_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'email': email,
      'phone': phone,
      'address': address,
      'insurance_info': insuranceInfo,
      'emergency_contact_name': emergencyContact?.name,
      'emergency_contact_phone': emergencyContact?.phone,
      'emergency_contact_relationship': emergencyContact?.relationship,
      'status': status.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'archived_at': archivedAt?.toIso8601String(),
    };
  }

  /// Convert to domain entity
  Patient toEntity() {
    return Patient(
      id: id,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      email: email,
      phone: phone,
      address: address,
      insuranceInfo: insuranceInfo,
      emergencyContact: emergencyContact,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      archivedAt: archivedAt,
    );
  }
}