import 'package:flutter_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.createdAt,
    // required super.firstname,
    // required super.lastname,
  });

  factory UserModel.fromSubapaseUser(dynamic supabaseUser) {
    return UserModel(
      id: supabaseUser.id as String,
      email: supabaseUser.email as String,
      createdAt: DateTime.parse(supabaseUser.createdAt as String),
      // firstname: supabaseUser.firstname as String,
      // lastname: supabaseUser.lastname as String,
    );
  }
}
