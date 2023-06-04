import 'package:flutter/material.dart';

extension NavigatorPush on BuildContext {
  Future<dynamic> pop<T extends Widget>({dynamic argument}) async =>
      Navigator.pop(this, argument);

  Future<dynamic> push<T extends Widget>(T page,
      {RouteSettings? routeSettings,
      bool fullscreenDialog = false,
      bool maintainState = true}) async {
    await Navigator.of(this).push(MaterialPageRoute<Widget>(
        builder: (BuildContext ctx) => page,
        settings: routeSettings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog));
  }

  Future<dynamic> pushAndRemoveUntil<T extends Widget>(T page,
      {RouteSettings? routeSettings,
      bool fullscreenDialog = false,
      bool maintainState = true}) async {
    await Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute<Widget>(
            builder: (BuildContext ctx) => page,
            settings: routeSettings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog),
        (Route<dynamic> route) => false);
  }
}
