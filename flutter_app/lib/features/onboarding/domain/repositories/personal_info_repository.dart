import 'package:PraxisPilot/features/onboarding/domain/entities/personal_info.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';

abstract class PersonalInfoRepository {
  Future<Either<Failure, PersonalInfo>> getPersonalInfo();

  Future<Either<Failure, Unit>> setPersonalInfo(PersonalInfo personalInfo);
}