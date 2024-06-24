import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable{}

class LoadUsers extends UsersEvent {
  @override
  List<Object?> get props => [];
}

class DeleteUser extends UsersEvent {
  final String userId;

  DeleteUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class MakeAdmin extends UsersEvent {
  final String userId;

  MakeAdmin(this.userId);

  @override
  List<Object?> get props => [userId];
}
class DemoteAdmin extends UsersEvent {
  final String userId;

  DemoteAdmin(this.userId);

  @override
  List<Object?> get props => [userId];
}
class MakeSuperAdmin extends UsersEvent {
  final String userId;

  MakeSuperAdmin(this.userId);

  @override
  List<Object?> get props => [userId];
}
