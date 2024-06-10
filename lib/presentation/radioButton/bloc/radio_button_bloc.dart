import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'radio_button_event.dart';
part 'radio_button_state.dart';

class RadioButtonBloc extends Bloc<RadioButtonEvent, RadioButtonState> {
  RadioButtonBloc() : super(RadioButtonState()) {
    on<RadioButtonChanged>(_onRadioButtonChanged);
  }
  _onRadioButtonChanged(
      RadioButtonChanged event, Emitter<RadioButtonState> emit) async{
    emit(
      state.copyWith(
        accountNumberController:TextEditingController(),
        banmkNameController:TextEditingController() ,
          selectedOption: event.selectedOption,
          showTextField: event.showTextField,
          ),
    );
  }
}
