import 'package:PraxisPilot/features/onboarding/domain/entities/personal_info.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/personal_info_repository.dart';

class SetPersonalInfo {
  final PersonalInfoRepository repository;

  SetPersonalInfo({required this.repository});

  Future<Either<Failure, void>> call({
    required PersonalInfo personalInfo,
  }) async {
    return await repository.setPersonalInfo(personalInfo);
  }
}