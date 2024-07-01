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

  // Set up the Bloc observer for state management logging
  // Bloc.observer = AppBlocObserver();

  // Initialize dependency injection
  configInjector();

  // Initialize Firebase (if required)
  await ApiClient.initializeFirebase();

  // Set the system UI overlay style for status bar and navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Lock the device orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    // Initialize shared preferences and logger
    PrefUtils().init();
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);

    // Run the Flutter application
    runApp(
      // Optionally enable DevicePreview for development
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => App(),
      // ),
      App(),
    );
  });
}
