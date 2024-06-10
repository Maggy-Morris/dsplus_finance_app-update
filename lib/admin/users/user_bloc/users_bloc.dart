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

  void _loadInitialData() {
    add(LoadUsers());
  }

  void _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    try {
      await emit.forEach<QuerySnapshot>(
        FirebaseFirestore.instance.collection('users').snapshots(),
        onData: (snapshot) {
          final List<User> admins = [];
          final List<User> users = [];

          snapshot.docs.forEach((doc) {
            Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
            userData['id'] = doc.id;
            User user = User.fromJson(userData);

            if (user.role == 'Admin') {
              admins.add(user);
            } else {
              users.add(user);
            }
          });

          return UsersState(admins: admins, users: users);
        },
        onError: (error, stackTrace) {
          print('Error loading users: $error');
          return UsersState(admins: [], users: []);
        },
      );
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(event.userId).delete();
      // Trigger a state refresh
      _loadInitialData();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<void> _onMakeAdmin(MakeAdmin event, Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(event.userId).update({
        'role': 'Admin',
      });
      // Trigger a state refresh
      _loadInitialData();
    } catch (e) {
      print('Error making user admin: $e');
    }
  }
}
