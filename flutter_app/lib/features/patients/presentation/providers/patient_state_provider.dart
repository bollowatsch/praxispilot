import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/create_patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/get_patients.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/update_patient.dart';
import 'package:PraxisPilot/features/patients/presentation/providers/patient_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patient_state_provider.g.dart';

/// State for patient management
class PatientState {
  final List<Patient> patients;
  final Patient? selectedPatient;
  final bool isLoading;
  final String? errorMessage;
  final PatientStatus? statusFilter;
  final String? searchQuery;

  const PatientState({
    this.patients = const [],
    this.selectedPatient,
    this.isLoading = false,
    this.errorMessage,
    this.statusFilter,
    this.searchQuery,
  });

  PatientState copyWith({
    List<Patient>? patients,
    Patient? selectedPatient,
    bool? isLoading,
    String? errorMessage,
    PatientStatus? statusFilter,
    String? searchQuery,
    bool clearSelectedPatient = false,
    bool clearError = false,
    bool clearStatusFilter = false,
    bool clearSearchQuery = false,
  }) {
    return PatientState(
      patients: patients ?? this.patients,
      selectedPatient:
          clearSelectedPatient ? null : (selectedPatient ?? this.selectedPatient),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

/// Patient state provider
@Riverpod(keepAlive: true)
class PatientStateNotifier extends _$PatientStateNotifier {
  @override
  PatientState build() {
    // Load patients on initialization with no filters
    Future.microtask(() => loadPatients(status: null, searchQuery: null));
    return const PatientState();
  }

  /// Load patients with optional filters
  Future<void> loadPatients({
    PatientStatus? status,
    String? searchQuery,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      statusFilter: status,
      searchQuery: searchQuery,
      clearStatusFilter: status == null,
      clearSearchQuery: searchQuery == null || searchQuery.isEmpty,
    );

    final params = GetPatientsParams(
      status: status,
      searchQuery: searchQuery,
    );

    final result = await ref.read(getPatientsProvider).call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (patients) {
        state = state.copyWith(
          isLoading: false,
          patients: patients,
          clearError: true,
        );
      },
    );
  }

  /// Select a patient
  void selectPatient(Patient? patient) {
    state = state.copyWith(
      selectedPatient: patient,
      clearSelectedPatient: patient == null,
    );
  }

  /// Create a new patient
  Future<bool> createPatient(CreatePatientParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(createPatientProvider).call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (patient) {
        // Reload patients after creation, preserving current filters
        loadPatients(
          status: state.statusFilter,
          searchQuery: state.searchQuery,
        );
        return true;
      },
    );
  }

  /// Update a patient
  Future<bool> updatePatient(UpdatePatientParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(updatePatientProvider).call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (patient) {
        // Reload patients after update, preserving current filters
        loadPatients(
          status: state.statusFilter,
          searchQuery: state.searchQuery,
        );
        return true;
      },
    );
  }

  /// Set status filter
  void setStatusFilter(PatientStatus? status) {
    loadPatients(
      status: status,
      searchQuery: state.searchQuery,
    );
  }

  /// Set search query
  void setSearchQuery(String? query) {
    loadPatients(
      status: state.statusFilter,
      searchQuery: query,
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}