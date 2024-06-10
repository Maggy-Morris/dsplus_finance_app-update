part of 'radio_button_bloc.dart';


abstract class RadioButtonEvent {}

class RadioButtonChanged extends RadioButtonEvent {
  final String selectedOption;
  final bool showTextField;

  RadioButtonChanged(
      {required this.selectedOption, required this.showTextField});
}
