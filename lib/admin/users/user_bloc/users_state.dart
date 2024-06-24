import '../presentaion/widgets/user_model.dart';

class UsersState {
  final List<UserModel> admins;
  final List<UserModel> users;

  UsersState({
    this.admins = const [],
    this.users = const [],
  });
}
