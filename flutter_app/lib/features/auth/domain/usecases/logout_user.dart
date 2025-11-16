import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUser implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.signOut();
  }
}
