import 'dart:async';

import 'package:dsplus_finance/data/models/login/post_login_req.dart';
import 'package:dsplus_finance/data/models/login/post_login_resp.dart';
import 'package:dsplus_finance/data/repository/repository.dart';
import 'package:dsplus_finance/presentation/login_page/models/login_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../core/app/app_export.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(initialState) {
    on<LoginInitialEvent>(_onInitialize);
    on<ChangePasswordVisibilityEvent>(_changePasswordVisibility);
    on<CreateLoginEvent>(_callCreateLogin);
  }

  final _repository = Repository();

  PostLoginResp postLoginResp = PostLoginResp();

  _changePasswordVisibility(
    ChangePasswordVisibilityEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isShowPassword: event.value));
  }

  _onInitialize(
    LoginInitialEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
        isShowPassword: true));
  }

  FutureOr<void> _callCreateLogin(
    CreateLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    PostLoginReq postLoginReq = PostLoginReq(
      email: state.emailController?.text ?? '',
      password: state.passwordController?.text ?? '',
    );
    await _repository.createLogin(user: postLoginReq).then((value) async {
      postLoginResp = value;
      _onCreateLoginSuccess(value, emit);
      event.onCreateLoginEventSuccess.call();
    }).onError((error, stackTrace) {
      //implement error call
      _onCreateLoginError();
      event.onCreateLoginEventError.call();
    });
  }

  void _onCreateLoginSuccess(
    PostLoginResp resp,
    Emitter<LoginState> emit,
  ) {
    PrefUtils().setId(resp.data?.id ?? '');
    emit(
      state.copyWith(
        loginModelObj: state.loginModelObj?.copyWith(),
      ),
    );
  }

  void _onCreateLoginError() {
    //implement error method body...
  }
}
