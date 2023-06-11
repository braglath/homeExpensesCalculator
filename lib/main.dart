import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/screens/registration/home_setup.dart';
import 'package:homeexpensecalculator/utils/app_providers.dart';
import 'package:homeexpensecalculator/utils/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: AppProviders.providers,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Expense Calculator',
          theme: AppTheme.light,
          home: const RegistrationHomeSetupScreen(),
        ),
      );
}
