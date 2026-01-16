import 'package:PraxisPilot/core/providers/supabase_provider.dart';
import 'package:PraxisPilot/features/patients/data/datasources/patient_remote_datasource.dart';
import 'package:PraxisPilot/features/patients/data/repositories/patient_repository_impl.dart';
import 'package:PraxisPilot/features/patients/domain/repositories/patient_repository.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/archive_patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/check_duplicates.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/create_patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/delete_patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/get_patient_by_id.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/get_patients.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/restore_patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/update_patient.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patient_providers.g.dart';

@riverpod
PatientRemoteDataSource patientRemoteDataSource(Ref ref) {
  return PatientRemoteDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
PatientRepository patientRepository(Ref ref) {
  return PatientRepositoryImpl(ref.watch(patientRemoteDataSourceProvider));
}

// use cases
@riverpod
CreatePatient createPatient(Ref ref) {
  return CreatePatient(ref.watch(patientRepositoryProvider));
}

@riverpod
GetPatients getPatients(Ref ref) {
  return GetPatients(ref.watch(patientRepositoryProvider));
}

@riverpod
GetPatientById getPatientById(Ref ref) {
  return GetPatientById(ref.watch(patientRepositoryProvider));
}

@riverpod
UpdatePatient updatePatient(Ref ref) {
  return UpdatePatient(ref.watch(patientRepositoryProvider));
}

@riverpod
ArchivePatient archivePatient(Ref ref) {
  return ArchivePatient(ref.watch(patientRepositoryProvider));
}

@riverpod
RestorePatient restorePatient(Ref ref) {
  return RestorePatient(ref.watch(patientRepositoryProvider));
}

@riverpod
DeletePatient deletePatient(Ref ref) {
  return DeletePatient(ref.watch(patientRepositoryProvider));
}

@riverpod
CheckDuplicates checkDuplicates(Ref ref) {
  return CheckDuplicates(ref.watch(patientRepositoryProvider));
}
