import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../core/app/app_export.dart';
import 'package:dsplus_finance/presentation/splash_screen/models/splash_model.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(SplashState initialState) : super(initialState) {
    on<SplashInitialEvent>(_onInitialize);
  }

  _onInitialize(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    final String? loggedInUserId = PrefUtils().getId();
    Future.delayed(const Duration(seconds: 3), () {
      if (loggedInUserId?.isNotEmpty ?? false) {
        debugPrint('id:$loggedInUserId');
        NavigatorService.popAndPushNamed(AppRoutes.homePageContainerScreen);
      } else {
        NavigatorService.popAndPushNamed(AppRoutes.loginPageTabContainerScreen);
      }
    });
  }
}
