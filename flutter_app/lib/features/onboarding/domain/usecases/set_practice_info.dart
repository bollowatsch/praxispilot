import 'package:PraxisPilot/features/onboarding/domain/entities/practice_info.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/practice_info_repository.dart';

class SetPracticeInfo {
  final PracticeInfoRepository repository;

  SetPracticeInfo({required this.repository});

  Future<Either<Failure, void>> call({
    required PracticeInfo practiceInfo,
  }) async {
    return await repository.setPracticeInfo(practiceInfo);
  }
}