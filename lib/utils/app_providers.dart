import 'package:homeexpensecalculator/providers/registration/home_setup_provider.dart';
import 'package:homeexpensecalculator/providers/services/services_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  AppProviders._internal();
  factory AppProviders() => _singleton;
  static final AppProviders _singleton = AppProviders._internal();

  static List<SingleChildWidget> providers = <ChangeNotifierProvider<dynamic>>[
    ChangeNotifierProvider<ServicesProvider>(create: (_) => ServicesProvider()),
    ChangeNotifierProvider<RegistrationHomeSetupProvider>(
        create: (_) => RegistrationHomeSetupProvider()),
  ];
}
