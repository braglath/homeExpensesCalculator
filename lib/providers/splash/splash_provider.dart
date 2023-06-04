import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SplashProvider extends ChangeNotifier {
  InternetConnectionStatus _internetConnection =
      InternetConnectionStatus.connected;
  InternetConnectionStatus get internetConnection => _internetConnection;

  void setInternetConnectionState(InternetConnectionStatus status) {
    _internetConnection = status;
    notifyListeners();
  }

  void resetAllValues() {
    _internetConnection = InternetConnectionStatus.connected;
    notifyListeners();
  }
}
