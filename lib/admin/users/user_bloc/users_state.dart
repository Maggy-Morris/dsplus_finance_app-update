import 'package:equatable/equatable.dart';

import '../presentaion/widgets/user_model.dart';

class UsersState extends Equatable{
  final List<User> admins;
  final List<User> users;
  final List<User> superAdmins;

  UsersState({
    this.admins = const [],
    this.users = const [],
    this.superAdmins = const [],
  });

  @override
  List<Object?> get props => [admins, users, superAdmins];
}
