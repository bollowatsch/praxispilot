import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_preferences.dart';

abstract class UserPreferencesRemoteDataSource {
  Future<UserPreferencesModel> getUserPreferences();
  Future<void> setUserPreferences(UserPreferencesModel userPreferences);
}

class UserPreferencesRemoteDataSourceImpl
    implements UserPreferencesRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserPreferencesRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserPreferencesModel> getUserPreferences() async {
    try {
      final response =
          await supabaseClient
              .from('user_preferences')
              .select(
                'theme_mode, language, timezone',
              )
              .maybeSingle();
      if (response == null) {
        throw const ServerException('Datarow for user not found');
      }
      return UserPreferencesModel.fromMap(map: response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> setUserPreferences(UserPreferencesModel userPreferences) async {
    try {
      supabaseClient.from('user_preferences').upsert(userPreferences.toMap());
    } on PostgrestException catch (e) {
      throw ServerException('Error setting user preferences: ${e.code}');
    }
  }
}
