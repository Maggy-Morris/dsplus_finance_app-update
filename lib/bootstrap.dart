import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dsplus_finance/bloc_observer.dart';
import 'package:dsplus_finance/core/di/injector.dart';
import 'package:dsplus_finance/data/apiClient/api_client.dart';
// import 'package:dsplus_finance/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app/app_export.dart';

/// A global key to access the state of [ScaffoldMessenger] widget from anywhere
/// in the application.
GlobalKey<ScaffoldMessengerState> globalMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError =
      (details) => log(details.exceptionAsString(), stackTrace: details.stack);

  // Bloc.observer = AppBlocObserver();

  configInjector();

  await ApiClient.initializeFirebase();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    PrefUtils().init();
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(
      // DevicePreview(

      App(),
      // )
    );
  });
}
