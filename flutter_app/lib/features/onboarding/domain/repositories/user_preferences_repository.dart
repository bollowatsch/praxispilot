import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';

abstract class UserPreferencesRepository {
  Future<Either<Failure, UserPreferences>> getUserPreferences();

  Future<Either<Failure, Unit>> setUserPreferences(
    UserPreferences userPreferences,
  );
}
