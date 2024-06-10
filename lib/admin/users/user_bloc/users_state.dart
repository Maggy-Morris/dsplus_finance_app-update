import '../presentaion/widgets/user_model.dart';

class UsersState {
  final List<User> admins;
  final List<User> users;

  UsersState({
    this.admins = const [],
    this.users = const [],
  });
}
