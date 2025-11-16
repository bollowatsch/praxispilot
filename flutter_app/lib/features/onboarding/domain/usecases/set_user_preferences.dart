import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/user_preferences_repository.dart';

class SetUserPreferences {
  final UserPreferencesRepository repository;

  SetUserPreferences({required this.repository});

  Future<Either<Failure, void>> call({
    required UserPreferences userPreferences,
  }) async {
    return await repository.setUserPreferences(userPreferences);
  }
}
