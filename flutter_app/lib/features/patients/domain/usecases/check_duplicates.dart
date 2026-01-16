import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckDuplicates implements UseCase<List<Patient>, CheckDuplicatesParams> {
  final PatientRepository repository;

  CheckDuplicates(this.repository);

  @override
  Future<Either<Failure, List<Patient>>> call(
    CheckDuplicatesParams params,
  ) async {
    return await repository.checkDuplicates(
      firstName: params.firstName,
      lastName: params.lastName,
      dateOfBirth: params.dateOfBirth,
    );
  }
}

class CheckDuplicatesParams {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  CheckDuplicatesParams({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });
}