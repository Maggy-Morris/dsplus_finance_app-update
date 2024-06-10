// import 'package:firebase_auth_youtube/colors.dart';
import 'package:flutter/material.dart';

import 'spining_lines_loader.dart';

Widget loadingIndicator({Color? color}){
  return Center(
    child: SpinningLinesLoader(
      color: color ?? Color(0xff8871e4),
      duration: const Duration(milliseconds: 3000),
      itemCount: 3,
      size: 50,
      lineWidth: 2,
    ),
  );
}