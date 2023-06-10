import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/providers/services/services_provider.dart';
import 'package:homeexpensecalculator/screens/services/services_screen.dart';
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
        providers: <ChangeNotifierProvider<dynamic>>[
          ChangeNotifierProvider<ServicesProvider>(
              create: (_) => ServicesProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Expense Calculator',
          theme: AppTheme.light,
          home: const ServicesView(),
        ),
      );
}
