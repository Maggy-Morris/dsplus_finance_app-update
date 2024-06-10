import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../core/app/app_export.dart';
import 'package:dsplus_finance/presentation/login_page_tab_container_screen/models/login_page_tab_container_model.dart';
part 'login_page_tab_container_event.dart';
part 'login_page_tab_container_state.dart';

class LoginPageTabContainerBloc
    extends Bloc<LoginPageTabContainerEvent, LoginPageTabContainerState> {
  LoginPageTabContainerBloc(LoginPageTabContainerState initialState)
      : super(initialState) {
    on<LoginPageTabContainerInitialEvent>(_onInitialize);
  }

  _onInitialize(
    LoginPageTabContainerInitialEvent event,
    Emitter<LoginPageTabContainerState> emit,
  ) async {}
}
