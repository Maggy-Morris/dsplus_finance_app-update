import 'dart:developer';

import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('AppBlocObserver ${bloc.runtimeType} $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('AppBlocObserver ${bloc.runtimeType} $error $stackTrace');

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    log('AppBlocObserver ${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('AppBlocObserver ${bloc.runtimeType} $transition');
  }
}
