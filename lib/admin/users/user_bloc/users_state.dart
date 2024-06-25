import 'package:equatable/equatable.dart';

import '../presentaion/widgets/user_model.dart';

class UsersState extends Equatable{
  final List<UserModel> admins;
  final List<UserModel> users;
  final List<UserModel> superAdmins;

  final String currentUserRole;


  UsersState({
    this.admins = const [],
    this.users = const [],
    this.superAdmins = const [],
    this.currentUserRole = '',
  });

  UsersState copyWith({
    List<UserModel>? admins,
    List<UserModel>? users,
    List<UserModel>? superAdmins,
    String? currentUserRole,
  }) {
    return UsersState(
      admins: admins ?? this.admins,
      users: users ?? this.users,
      superAdmins: superAdmins ?? this.superAdmins,
    );
  }

  @override
  List<Object?> get props => [admins, users, superAdmins];
}
