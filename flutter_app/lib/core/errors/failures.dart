abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthenticationException implements Exception {
  final String message;
  const AuthenticationException(this.message);
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}
