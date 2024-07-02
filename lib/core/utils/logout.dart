import 'package:dsplus_finance/core/utils/pref_utils.dart';
import 'package:dsplus_finance/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'navigator_service.dart';

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    PrefUtils().clearPreferencesData();
    NavigatorService.pushNamedAndRemoveUntil(
        AppRoutes.loginPageTabContainerScreen

    );
  } catch (e) {
    debugPrint('Error signing out: $e');
  }
}