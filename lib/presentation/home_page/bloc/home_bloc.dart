import 'dart:async';

import 'package:dsplus_finance/data/apiClient/api_client.dart';
import 'package:dsplus_finance/presentation/home_page/models/transactions_model.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app/app_export.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<HomeEvent>(_onInitialize);
    on<AllTransactionsEvent>(_onAllTransactionsEvent);
  }
  StreamSubscription<List<TransactionsModel>>? transactionsSubscription;
  _onInitialize(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) {
 
    transactionsSubscription = ApiClient().getAllTransactions().listen((value){
      add(AllTransactionsEvent(allTransactions: value));
    });
    // emit(state.copyWith(
    //     homeModelObj: state.homeModelObj
    //         ?.copyWith(homePageItemList: fillHomePageItemList())));
  }
  _onAllTransactionsEvent(AllTransactionsEvent event, Emitter<HomeState> emit){
    try{
      transactionsSubscription?.cancel();
    }catch(_){}
    emit(state.copyWith(
        allTransactions: event.allTransactions));
    //      try{
    //   transactionsSubscription?.cancel();
    // }catch(_){}
  }





  @override
  Future<void> close() {
    try{
      transactionsSubscription?.cancel();
    }catch(_){}
    
    return super.close();
  }


}
