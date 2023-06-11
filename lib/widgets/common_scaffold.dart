import 'package:flutter/material.dart';

abstract class CommonScaffold<S extends StatefulWidget> extends State<S> {
  @protected
  Widget buildBody(BuildContext context);

  PreferredSizeWidget? buildAppBar() => null;

  ///Default FloatingActionButton
  Widget? buildFloatingActionButton() => null;

  FloatingActionButtonLocation? floatingActionButtonLocation() => null;

  Widget? bottomNavBar() => null;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(),
        bottomNavigationBar: FractionallySizedBox(
          heightFactor: 0.1,
          widthFactor: 1,
          child: bottomNavBar(),
        ),
        floatingActionButton: buildFloatingActionButton(),
        floatingActionButtonLocation: floatingActionButtonLocation(),
        body: buildBody(context),
      );
}
