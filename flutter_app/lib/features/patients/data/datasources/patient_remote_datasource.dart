import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/features/patients/data/models/patient_model.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for patient operations
class PatientRemoteDataSource {
  final SupabaseClient _supabase;

  PatientRemoteDataSource(this._supabase);

  /// Get current user's profile ID
  Future<String> _getUserProfileId() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const ServerException('User not authenticated');
    }

    final response =
        await _supabase
            .from('user_profiles')
            .select('id')
            .eq('user_id', userId)
            .single();

    return response['id'] as String;
  }

  /// Create a new patient
  Future<PatientModel> createPatient({
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
      final userProfileId = await _getUserProfileId();

      final data = {
        'user_profile_id': userProfileId,
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
        'email': email,
        'phone': phone,
        'address': address,
        'insurance_info': insuranceInfo,
        'emergency_contact_name': emergencyContactName,
        'emergency_contact_phone': emergencyContactPhone,
        'emergency_contact_relationship': emergencyContactRelationship,
        'status': 'active',
      };

      final response =
          await _supabase.from('patients').insert(data).select().single();

      return PatientModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to create patient: ${e.toString()}');
    }
  }

  /// Get patient by ID
  Future<PatientModel> getPatientById(String patientId) async {
    try {
      final response =
          await _supabase
              .from('patients')
              .select()
              .eq('id', patientId)
              .single();

      return PatientModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get patient: ${e.toString()}');
    }
  }

  /// Get all patients for current therapist
  Future<List<PatientModel>> getPatients({
    PatientStatus? status,
    String? searchQuery,
  }) async {
    try {
      final userProfileId = await _getUserProfileId();

      // Start with base query and apply filters
      var query = _supabase
          .from('patients')
          .select()
          .eq('user_profile_id', userProfileId);

      // Filter by status if provided
      if (status != null) {
        query = query.eq('status', status.toJson());
      }

      // Filter by search query if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final searchLower = searchQuery.toLowerCase();
        query = query.or(
          'first_name.ilike.%$searchLower%,'
          'last_name.ilike.%$searchLower%,'
          'email.ilike.%$searchLower%',
        );
      }

      // Apply ordering after all filters
      final response = await query
          .order('last_name', ascending: true)
          .order('first_name', ascending: true);

      return (response as List)
          .map((json) => PatientModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get patients: ${e.toString()}');
    }
  }

  /// Update patient information
  Future<PatientModel> updatePatient({
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
      final data = <String, dynamic>{};

      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      }
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;
      if (insuranceInfo != null) data['insurance_info'] = insuranceInfo;
      if (emergencyContactName != null) {
        data['emergency_contact_name'] = emergencyContactName;
      }
      if (emergencyContactPhone != null) {
        data['emergency_contact_phone'] = emergencyContactPhone;
      }
      if (emergencyContactRelationship != null) {
        data['emergency_contact_relationship'] = emergencyContactRelationship;
      }

      final response =
          await _supabase
              .from('patients')
              .update(data)
              .eq('id', patientId)
              .select()
              .single();

      return PatientModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update patient: ${e.toString()}');
    }
  }

  /// Archive a patient (soft delete)
  Future<void> archivePatient(String patientId) async {
    try {
      await _supabase
          .from('patients')
          .update({'status': 'archived'})
          .eq('id', patientId);
    } catch (e) {
      throw ServerException('Failed to archive patient: ${e.toString()}');
    }
  }

  /// Restore an archived patient
  Future<void> restorePatient(String patientId) async {
    try {
      await _supabase
          .from('patients')
          .update({'status': 'active'})
          .eq('id', patientId);
    } catch (e) {
      throw ServerException('Failed to restore patient: ${e.toString()}');
    }
  }

  /// Delete a patient permanently (hard delete)
  Future<void> deletePatient(String patientId) async {
    try {
      await _supabase.from('patients').delete().eq('id', patientId);
    } catch (e) {
      throw ServerException('Failed to delete patient: ${e.toString()}');
    }
  }

  /// Check for potential duplicate patients
  Future<List<PatientModel>> checkDuplicates({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  }) async {
    try {
      final userProfileId = await _getUserProfileId();
      final dobString = dateOfBirth.toIso8601String().split('T')[0];

      final response = await _supabase
          .from('patients')
          .select()
          .eq('user_profile_id', userProfileId)
          .ilike('first_name', firstName)
          .ilike('last_name', lastName)
          .eq('date_of_birth', dobString);

      return (response as List)
          .map((json) => PatientModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to check duplicates: ${e.toString()}');
    }
  }
}
