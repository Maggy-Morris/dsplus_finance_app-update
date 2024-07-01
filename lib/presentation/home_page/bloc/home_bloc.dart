import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_model.dart';
import 'package:dsplus_finance/data/apiClient/api_client.dart';
import 'package:dsplus_finance/presentation/home_page/models/transactions_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/app/app_export.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<HomeEvent>(_onInitialize);
    on<AllTransactionsEvent>(_onAllTransactionsEvent);
    on<GetUserData>(_onGetUserData);
  }
  StreamSubscription<List<TransactionsModel>>? transactionsSubscription;
  _onInitialize(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) {
    transactionsSubscription = ApiClient().getAllTransactions().listen((value) {
      add(AllTransactionsEvent(allTransactions: value));
    });
    // emit(state.copyWith(
    //     homeModelObj: state.homeModelObj
    //         ?.copyWith(homePageItemList: fillHomePageItemList())));
  }

  _onAllTransactionsEvent(AllTransactionsEvent event, Emitter<HomeState> emit) {
    try {
      transactionsSubscription?.cancel();
    } catch (_) {}
    emit(state.copyWith(allTransactions: event.allTransactions));
    //      try{
    //   transactionsSubscription?.cancel();
    // }catch(_){}
  }

  _onGetUserData(GetUserData event, Emitter<HomeState> emit) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          emit(state.copyWith(
              userModel: UserModel(
                  jobTitle: documentSnapshot.get('jobTitle'),
                  image: documentSnapshot.get('userImageUrl'),
                  id: documentSnapshot.get('uid'),
                  name: documentSnapshot.get('name'),
                  email: documentSnapshot.get('email'),
                  role: documentSnapshot.get('role'))));
          // prefs.setString('role', documentSnapshot.get('role'));
          // prefs.setString('userName', documentSnapshot.get('name'));
          // prefs.setString('jobTitle', documentSnapshot.get('jobTitle'));
          // prefs.setString('imageUrl', documentSnapshot.get('imageUrl'));
        }
      });
    } catch (_) {}
    // emit(state.copyWith(allTransactions: event.allTransactions));
    //      try{
    //   transactionsSubscription?.cancel();
    // }catch(_){}
  }

  @override
  Future<void> close() {
    try {
      transactionsSubscription?.cancel();
    } catch (_) {}

    return super.close();
  }
}
