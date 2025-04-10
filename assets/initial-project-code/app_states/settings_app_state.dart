import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart';

class SettingsAppState extends ChangeNotifier {
  bool get cachingPause => sharedPrefs.getBool("cachingPause") ?? true;
  set cachingPause(bool value) {
    sharedPrefs.setBool("cachingPause", value);
    notifyListeners();
  }
}
