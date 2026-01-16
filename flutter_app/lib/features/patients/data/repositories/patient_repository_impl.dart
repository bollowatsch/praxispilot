import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/features/patients/data/datasources/patient_remote_datasource.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Implementation of PatientRepository
class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource _remoteDataSource;

  PatientRepositoryImpl(this._remoteDataSource);

  @override
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
  }) async {
    try {
      final patient = await _remoteDataSource.createPatient(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        email: email,
        phone: phone,
        address: address,
        insuranceInfo: insuranceInfo,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactRelationship: emergencyContactRelationship,
      );
      return Right(patient.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Patient>> getPatientById(String patientId) async {
    try {
      final patient = await _remoteDataSource.getPatientById(patientId);
      return Right(patient.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Patient>>> getPatients({
    PatientStatus? status,
    String? searchQuery,
  }) async {
    try {
      final patients = await _remoteDataSource.getPatients(
        status: status,
        searchQuery: searchQuery,
      );
      return Right(patients.map((p) => p.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
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
  }) async {
    try {
      final patient = await _remoteDataSource.updatePatient(
        patientId: patientId,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        email: email,
        phone: phone,
        address: address,
        insuranceInfo: insuranceInfo,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactRelationship: emergencyContactRelationship,
      );
      return Right(patient.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> archivePatient(String patientId) async {
    try {
      await _remoteDataSource.archivePatient(patientId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> restorePatient(String patientId) async {
    try {
      await _remoteDataSource.restorePatient(patientId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePatient(String patientId) async {
    try {
      await _remoteDataSource.deletePatient(patientId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Patient>>> checkDuplicates({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  }) async {
    try {
      final patients = await _remoteDataSource.checkDuplicates(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      );
      return Right(patients.map((p) => p.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
