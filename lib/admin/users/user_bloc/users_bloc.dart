import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presentaion/widgets/user_model.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersState()) {
    on<LoadUsers>(_onLoadUsers);
    on<DeleteUser>(_onDeleteUser);
    on<MakeAdmin>(_onMakeAdmin);

    _loadInitialData();
  }

  void _loadInitialData() async {
    add(LoadUsers());
  }

  void _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final List<UserModel> admins = [];
      final List<UserModel> users = [];

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userData['id'] = doc.id;
        UserModel user = UserModel.fromJson(userData);

        if (user.role == 'Admin') {
          admins.add(user);
        } else {
          users.add(user);
        }
      });

      emit(UsersState(admins: admins, users: users));
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  void _onDeleteUser(DeleteUser event, Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.userId)
          .delete();
      emit(state); // Update state to trigger UI refresh
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  void _onMakeAdmin(MakeAdmin event, Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.userId)
          .update({
        'role': 'Admin',
      });
      _loadInitialData();
    } catch (e) {
      print('Error making user admin: $e');
    }
  }
}
