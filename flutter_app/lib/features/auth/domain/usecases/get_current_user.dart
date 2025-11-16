import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/auth/domain/entities/user.dart';
import 'package:PraxisPilot/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
