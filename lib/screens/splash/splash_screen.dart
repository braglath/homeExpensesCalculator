import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/providers/splash/splash_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<InternetConnectionStatus> internetConnectionState;
  InternetConnectionStatus internetConnection =
      InternetConnectionStatus.connected;
  late SplashProvider viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<SplashProvider>();
    internetConnectionState = InternetConnectionChecker()
        .onStatusChange
        .listen(viewModel.setInternetConnectionState);
  }

  @override
  Future<void> dispose() async {
    await internetConnectionState.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();
}
