import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetPatientById implements UseCase<Patient, String> {
  final PatientRepository repository;

  GetPatientById(this.repository);

  @override
  Future<Either<Failure, Patient>> call(String patientId) async {
    return await repository.getPatientById(patientId);
  }
}