import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/onboarding/domain/entities/preferences.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/user_preferences_repository.dart';

class GetUserPreferences {
  final UserPreferencesRepository repository;

  GetUserPreferences({required this.repository});

  Future<Either<Failure, UserPreferences>> call({
    required NoParams params,
  }) async {
    return await repository.getUserPreferences();
  }
}
