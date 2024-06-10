import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/ask_for_cash_model.dart';

part 'ask_for_cash_bloc_event.dart';
part 'ask_for_cash_bloc_state.dart';

class AskForCashBlocBloc
    extends Bloc<AskForCashBlocEvent, AskForCashBlocState> {
  AskForCashBlocBloc(AskForCashBlocState askForCashBlocState)
      : super(AskForCashBlocState()) {
    on<AskForCashBlocEvent>(_onInitialize);
  }

  _onInitialize(
    AskForCashBlocEvent event,
    Emitter<AskForCashBlocState> emit,
  ) async {
    emit(state.copyWith(
      nameController: TextEditingController(),
      amountController: TextEditingController(),
    ));
  }
}
