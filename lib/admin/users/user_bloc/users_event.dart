abstract class UsersEvent {}

class LoadUsers extends UsersEvent {}

class DeleteUser extends UsersEvent {
  final String userId;

  DeleteUser(this.userId);
}

class MakeAdmin extends UsersEvent {
  final String userId;

  MakeAdmin(this.userId);
}
