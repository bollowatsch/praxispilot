import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdatePatient implements UseCase<Patient, UpdatePatientParams> {
  final PatientRepository repository;

  UpdatePatient(this.repository);

  @override
  Future<Either<Failure, Patient>> call(UpdatePatientParams params) async {
    return await repository.updatePatient(
      patientId: params.patientId,
      firstName: params.firstName,
      lastName: params.lastName,
      dateOfBirth: params.dateOfBirth,
      email: params.email,
      phone: params.phone,
      address: params.address,
      insuranceInfo: params.insuranceInfo,
      emergencyContactName: params.emergencyContactName,
      emergencyContactPhone: params.emergencyContactPhone,
      emergencyContactRelationship: params.emergencyContactRelationship,
    );
  }
}

class UpdatePatientParams {
  final String patientId;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? email;
  final String? phone;
  final String? address;
  final String? insuranceInfo;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelationship;

  UpdatePatientParams({
    required this.patientId,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.email,
    this.phone,
    this.address,
    this.insuranceInfo,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelationship,
  });
}