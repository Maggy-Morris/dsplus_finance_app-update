import 'package:firebase_auth/firebase_auth.dart';
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
    on<DemoteAdmin>(_onDemoteAdmin);
    on<MakeSuperAdmin>(_onMakeSuperAdmin);

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
          final List<UserModel> admins = [];
          final List<UserModel> users = [];
          final List<UserModel> superAdmins = [];

          snapshot.docs.forEach((doc) {
            Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
            userData['id'] = doc.id;
            UserModel user = UserModel.fromJson(userData);

            if (user.role == 'Admin') {
              admins.add(user);
            } else if (user.role == 'SuperAdmin') {
              superAdmins.add(user);
            }else {
              users.add(user);
            }
          });

          return UsersState(admins: admins, users: users , superAdmins: superAdmins);
        },
        onError: (error, stackTrace) {
          return UsersState(admins: [], users: [] , superAdmins: [] );
        },
      );
    } catch (e) {
      emit(UsersState(admins: [], users: [] , superAdmins: [] ));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('users')
          .doc(event.userId)
          .delete();
      // Trigger a state refresh
      _loadInitialData();
    } catch (e) {
      emit(UsersState(admins: [], users: [] , superAdmins: [] ));
    }
  }

  Future<void> _onMakeAdmin(MakeAdmin event, Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('users')
          .doc(event.userId)
          .update({
        'role': 'Admin',
      });
      // Trigger a state refresh
      _loadInitialData();
    } catch (e) {
      emit(UsersState(admins: [], users: [] , superAdmins: [] ));
    }
  }

  Future<void> _onDemoteAdmin(DemoteAdmin event,
      Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('users')
          .doc(event.userId)
          .update({
        'role': 'User',
      });
      // Trigger a state refresh
      _loadInitialData();
    } catch (e) {
      print('Error making user admin: $e');
    }
  }
  Future<void> _onMakeSuperAdmin(MakeSuperAdmin event,
      Emitter<UsersState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('users')
          .doc(event.userId)
          .update({
        'role': 'SuperAdmin',
      });
      // Trigger a state refresh
      _loadInitialData();
    } catch (e) {
      print('Error making user SuperAdmin: $e');
    }
  }

  currentUserRole() {
   final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((doc) {
      String role = doc.data()?['role'];
      print(role);
      return UsersState(currentUserRole: role);
    });
  }
}
