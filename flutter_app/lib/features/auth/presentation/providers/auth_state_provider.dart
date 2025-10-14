import 'package:flutter_app/core/usecases/usecase.dart';
import 'package:flutter_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app/features/auth/presentation/state/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/usecases/login_user.dart';

part 'auth_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AuthState build() {
    Future.microtask(() => _checkAuth());
    return const AuthState();
  }

  Future<void> _checkAuth() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(getCurrentUserProvider)(const NoParams());
    result.fold(
      (failure) => state = const AuthState(),
      (user) => state = state.copyWith(isLoading: false, currentUser: user),
    );
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final params = LoginParams(email: email, password: password);
    final result = await ref.read(loginUserProvider)(params);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          currentUser: user,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await ref.read(logoutUserProvider)(const NoParams());
    result.fold(
      (failure) =>
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
      (_) => state = state.clearUser(),
    );
  }
}
