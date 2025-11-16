import 'package:PraxisPilot/core/providers/supabase_provider.dart';
import 'package:PraxisPilot/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:PraxisPilot/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:PraxisPilot/features/auth/domain/usecases/get_current_user.dart';
import 'package:PraxisPilot/features/auth/domain/usecases/login_user.dart';
import 'package:PraxisPilot/features/auth/domain/usecases/logout_user.dart';
import 'package:PraxisPilot/features/auth/domain/usecases/signup_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRemoteDataSourceImpl authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(supabaseClient: ref.watch(supabaseClientProvider));

@riverpod
AuthRepositoryImpl authRepository(Ref ref) => AuthRepositoryImpl(
  remoteDataSource: ref.watch(authRemoteDataSourceProvider),
);

@riverpod
LoginUser loginUser(Ref ref) => LoginUser(ref.watch(authRepositoryProvider));

@riverpod
LogoutUser logoutUser(Ref ref) => LogoutUser(ref.watch(authRepositoryProvider));

@riverpod
SignUpUser signUpUser(Ref ref) => SignUpUser(ref.watch(authRepositoryProvider));

@riverpod
GetCurrentUser getCurrentUser(Ref ref) =>
    GetCurrentUser(ref.watch(authRepositoryProvider));
