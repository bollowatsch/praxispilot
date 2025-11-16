import 'package:PraxisPilot/core/providers/supabase_provider.dart';
import 'package:PraxisPilot/features/onboarding/data/datasources/preferences_remote_datasource.dart';
import 'package:PraxisPilot/features/onboarding/data/repositories/user_preferences_repository_impl.dart';
import 'package:PraxisPilot/features/onboarding/domain/repositories/user_preferences_repository.dart';
import 'package:PraxisPilot/features/onboarding/domain/usecases/get_user_preferences.dart';
import 'package:PraxisPilot/features/onboarding/domain/usecases/set_user_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_provider.g.dart';

@riverpod
UserPreferencesRemoteDataSourceImpl userPreferencesRemoteDataSource(Ref ref) =>
    UserPreferencesRemoteDataSourceImpl(
      supabaseClient: ref.read(supabaseClientProvider),
    );

@riverpod
UserPreferencesRepository userPreferencesRepository(Ref ref) =>
    UserPreferenceRepositoryImpl(
      remoteDataSource: ref.read(userPreferencesRemoteDataSourceProvider),
    );

@riverpod
SetUserPreferences setUserPreferences(Ref ref) => SetUserPreferences(
  repository: ref.watch(userPreferencesRepositoryProvider),
);

@riverpod
GetUserPreferences getUserPreferences(Ref ref) => GetUserPreferences(
  repository: ref.watch(userPreferencesRepositoryProvider),
);
