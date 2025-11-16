import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/features/onboarding/data/datasources/preferences_remote_datasource.dart';
import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart';
import 'package:PraxisPilot/features/onboarding/domain/repositories/user_preferences_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../models/user_preferences.dart';

class UserPreferenceRepositoryImpl implements UserPreferencesRepository {
  final UserPreferencesRemoteDataSource remoteDataSource;

  UserPreferenceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserPreferences>> getUserPreferences() async {
    try {
      final userPreferencesModel = await remoteDataSource.getUserPreferences();
      return right(userPreferencesModel.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setUserPreferences(
    UserPreferences userPreferences,
  ) async {
    try {
      final userPreferencesModel = UserPreferencesModel.fromEntity(
        entity: userPreferences,
      );
      await remoteDataSource.setUserPreferences(userPreferencesModel);
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
