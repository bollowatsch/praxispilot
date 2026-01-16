import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:fpdart/fpdart.dart';

/// Repository interface for patient operations
abstract class PatientRepository {
  /// Create a new patient
  Future<Either<Failure, Patient>> createPatient({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    String? email,
    String? phone,
    String? address,
    String? insuranceInfo,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelationship,
  });

  Future<Either<Failure, Patient>> getPatientById(String patientId);

  /// Get all patients for current therapist
  Future<Either<Failure, List<Patient>>> getPatients({
    PatientStatus? status,
    String? searchQuery,
  });

  /// Update patient information
  Future<Either<Failure, Patient>> updatePatient({
    required String patientId,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? email,
    String? phone,
    String? address,
    String? insuranceInfo,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelationship,
  });

  /// Archive a patient (soft delete)
  Future<Either<Failure, Unit>> archivePatient(String patientId);

  /// Restore an archived patient
  Future<Either<Failure, Unit>> restorePatient(String patientId);

  /// Delete a patient permanently (hard delete - only after retention period)
  Future<Either<Failure, Unit>> deletePatient(String patientId);

  /// Check for potential duplicate patients
  Future<Either<Failure, List<Patient>>> checkDuplicates({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  });
}
