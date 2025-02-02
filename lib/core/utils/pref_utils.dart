import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable
class PrefUtils {
  factory PrefUtils() {
    return _instance;
  }

  PrefUtils._internal();

  static SharedPreferences? _sharedPreferences;

  static final PrefUtils _instance = PrefUtils._internal();

  /// Initializes the [SharedPreferences] instance and sets it to the
  /// [_sharedPreferences] variable.
  ///
  /// This method should be called at the beginning of the application startup to
  /// ensure that [SharedPreferences] is ready to use.
  ///
  /// Throws an exception if there is an error while initializing the instance.
  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    debugPrint('SharedPreference Initialized');
  }

  /// Clears all data from the SharedPreferences instance.
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setId(String value) {
    return _sharedPreferences!.setString('id', value);
  }

  String getId() {
    try {
      return _sharedPreferences!.getString('id') ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> removeId() async {
    _sharedPreferences!.remove('id');
  }
}
