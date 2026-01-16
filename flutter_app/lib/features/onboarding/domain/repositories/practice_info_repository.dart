import 'package:PraxisPilot/features/onboarding/domain/entities/practice_info.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';

abstract class PracticeInfoRepository {
  Future<Either<Failure, PracticeInfo>> getPracticeInfo();

  Future<Either<Failure, Unit>> setPracticeInfo(PracticeInfo practiceInfo);
}