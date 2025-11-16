import 'package:PraxisPilot/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.createdAt,
  });

  factory UserModel.fromSubapaseUser(dynamic supabaseUser) {
    return UserModel(
      id: supabaseUser.id as String,
      email: supabaseUser.email as String,
      createdAt: DateTime.parse(supabaseUser.createdAt as String),
    );
  }
}
