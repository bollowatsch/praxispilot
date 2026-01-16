import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetPatients implements UseCase<List<Patient>, GetPatientsParams> {
  final PatientRepository repository;

  GetPatients(this.repository);

  @override
  Future<Either<Failure, List<Patient>>> call(GetPatientsParams params) async {
    return await repository.getPatients(
      status: params.status,
      searchQuery: params.searchQuery,
    );
  }
}

class GetPatientsParams {
  final PatientStatus? status;
  final String? searchQuery;

  const GetPatientsParams({
    this.status,
    this.searchQuery,
  });
}