import 'package:PraxisPilot/features/patients/domain/entities/emergency_contact.dart';

/// Patient entity representing a patient in the practice
class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? email;
  final String? phone;
  final String? address;
  final String? insuranceInfo; // Free-form text for insurance information
  final EmergencyContact? emergencyContact;
  final PatientStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.email,
    this.phone,
    this.address,
    this.insuranceInfo,
    this.emergencyContact,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });

  /// Full name of the patient
  String get fullName => '$firstName $lastName';

  /// Age of the patient in years
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Check if patient is active
  bool get isActive => status == PatientStatus.active;

  /// Check if patient is archived
  bool get isArchived => status == PatientStatus.archived;

  Patient copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? email,
    String? phone,
    String? address,
    String? insuranceInfo,
    EmergencyContact? emergencyContact,
    PatientStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      insuranceInfo: insuranceInfo ?? this.insuranceInfo,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }
}

/// Status of a patient - binary: active or archived
enum PatientStatus {
  active,
  archived;

  String toJson() => name;

  static PatientStatus fromJson(String value) {
    return PatientStatus.values.firstWhere((e) => e.name == value);
  }
}