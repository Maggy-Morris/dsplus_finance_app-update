part of 'users_cubit.dart';

enum UsersStatus { initial, loading, error ,adminSuccess , superAdminSuccess, userSuccess}

class UsersState extends Equatable {
  final List<UserModel> admins;
  final List<UserModel> users;
  final List<UserModel> superAdmins;

  UsersStatus status;
  final String currentUserRole;

  UsersState({
    this.admins = const [],
    this.users = const [],
    this.superAdmins = const [],
    this.currentUserRole = '',
    this.status = UsersStatus.initial,
  });

  UsersState copyWith({
    List<UserModel>? admins,
    List<UserModel>? users,
    List<UserModel>? superAdmins,
    String? currentUserRole,
    UsersStatus? status,
  }) {
    return UsersState(
      admins: admins ?? this.admins,
      users: users ?? this.users,
      superAdmins: superAdmins ?? this.superAdmins,
      currentUserRole: currentUserRole ?? this.currentUserRole,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [admins, users, superAdmins , status, currentUserRole];
}