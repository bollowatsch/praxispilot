import 'package:flutter_app/core/errors/failures.dart';
import 'package:flutter_app/core/usecases/usecase.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});
}

class SignUpUser implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpUser(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    if (params.email.isEmpty || params.password.isEmpty) {
      return Left(const AuthFailure('Email and password are mandatory'));
    }

    return await repository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}
