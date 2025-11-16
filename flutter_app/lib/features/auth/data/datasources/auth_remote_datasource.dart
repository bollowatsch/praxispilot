import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/features/auth/data/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel> getCurrentUser();
  Future<UserModel> signUp({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthenticationException('Login unsuccessful');
      }

      return UserModel.fromSubapaseUser(response.user!);
    } on AuthenticationException catch (e) {
      if (e.message.contains('Invalid')) {
        throw const AuthenticationException('Invalid user credentials');
      }
      throw AuthenticationException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: '//callback-URL', // TODO deep linking
      );

      if (response.user == null) {
        throw const AuthenticationException('User could not be created');
      }

      return UserModel.fromSubapaseUser(response.user!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await supabaseClient.auth.currentUser;

      if (response == null) {
        throw const AuthenticationException('You are not logged in');
      }

      return UserModel.fromSubapaseUser(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
