import 'package:dsplus_finance/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

void main()
// => bootstrap();
{
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.blue, // navigation bar color
  //   statusBarColor: Colors.pink, // status bar color
  // ));
  bootstrap();
}
