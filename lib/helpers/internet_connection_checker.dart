import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

class CheckInternetConnection {
  factory CheckInternetConnection() => _internetConnectionChecker;
  CheckInternetConnection._internal();
  static final CheckInternetConnection _internetConnectionChecker =
      CheckInternetConnection._internal();

  StreamSubscription<InternetConnectionStatus> checkConnectionState() =>
      InternetConnectionChecker()
          .onStatusChange
          .listen((InternetConnectionStatus result) async {
        if (result != InternetConnectionStatus.connected) {
          // isDeviceConnected =
          await InternetConnectionChecker().hasConnection;
        }
      });
}
