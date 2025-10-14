import '../../domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final User? currentUser;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.currentUser,
    this.errorMessage,
  });

  bool get isAuthenticated => currentUser != null;

  String get displayName => currentUser?.email.split('@').first ?? 'Benutzer';

  AuthState copyWith({
    bool? isLoading,
    User? currentUser,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  AuthState clearUser() {
    return const AuthState(
      isLoading: false,
      errorMessage: null,
      currentUser: null,
    );
  }

  AuthState clearError() {
    return copyWith(errorMessage: null);
  }
}
