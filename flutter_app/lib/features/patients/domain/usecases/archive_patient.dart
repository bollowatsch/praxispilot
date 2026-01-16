import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class ArchivePatient implements UseCase<Unit, String> {
  final PatientRepository repository;

  ArchivePatient(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String patientId) async {
    return await repository.archivePatient(patientId);
  }
}