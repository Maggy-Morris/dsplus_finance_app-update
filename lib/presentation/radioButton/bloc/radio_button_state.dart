part of 'radio_button_bloc.dart';

// ignore: must_be_immutable
class RadioButtonState extends Equatable {
  final String selectedOption;
  final bool showTextField;
  TextEditingController? banmkNameController;

  TextEditingController? accountNumberController;

  RadioButtonState({
    this.banmkNameController,
    this.accountNumberController,
    this.selectedOption = "",
    this.showTextField = false,
  });

  RadioButtonState copyWith({
    TextEditingController? accountNumberController,
    TextEditingController? banmkNameController,
    String? selectedOption,
    bool? showTextField,
  }) {
    return RadioButtonState(
      accountNumberController:
      accountNumberController ?? this.accountNumberController,
      banmkNameController: banmkNameController ?? this.banmkNameController,
      selectedOption: selectedOption ?? this.selectedOption,
      showTextField: showTextField ?? this.showTextField,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        accountNumberController,
        banmkNameController,
        selectedOption,
        showTextField,
      ];
}
