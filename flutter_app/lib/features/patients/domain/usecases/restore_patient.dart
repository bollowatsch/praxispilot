import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class RestorePatient implements UseCase<Unit, String> {
  final PatientRepository repository;

  RestorePatient(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String patientId) async {
    return await repository.restorePatient(patientId);
  }
}