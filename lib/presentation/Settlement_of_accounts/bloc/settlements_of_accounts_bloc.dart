import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/settlemetns_of_accounts_model.dart';

part 'settlements_of_accounts_event.dart';
part 'settlements_of_accounts_state.dart';

class SettlementsOfAccountsBloc
    extends Bloc<SettlementsOfAccountsEvent, SettlementsOfAccountsState> {
  SettlementsOfAccountsBloc(
      SettlementsOfAccountsState settlementsOfAccountsState)
      : super(SettlementsOfAccountsState()) {
    on<SettlementsOfAccountsEvent>(_onInitialize);
    on<EditDescrition>(_onEditDescrition);
    on<EditAmount>(_onEditAmount);
  }

  _onInitialize(
    SettlementsOfAccountsEvent event,
    Emitter<SettlementsOfAccountsState> emit,
  ) async {
    emit(state.copyWith(
      descriptionController: state.descriptionController,
      amountController: state.amountController,
    ));
  }

  _onEditDescrition(
    EditDescrition event,
    Emitter<SettlementsOfAccountsState> emit,
  ) {
    emit(state.copyWith(
      descriptionController: event.description,
    ));
  }

  _onEditAmount(
    EditAmount event,
    Emitter<SettlementsOfAccountsState> emit,
  ) {
    emit(state.copyWith(
      amountController: event.amount,
    ));
  }
}
