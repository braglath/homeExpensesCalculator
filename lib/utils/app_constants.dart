import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/utils/app_icons.dart';

class AppConstants {
  AppConstants._internal();
  factory AppConstants() => _singleton;
  static final AppConstants _singleton = AppConstants._internal();

  static List<PopupMenuEntry<dynamic>> servicesContextMenu({
    required Function()? favOnTap,
    required Function()? editOnTap,
    required Function()? commentOnTap,
    required Function()? deleteOnTap,
    required Function()? moveToOnTap,
    bool isExpenses = false,
  }) =>
      <PopupMenuEntry<dynamic>>[
        PopupMenuItem<dynamic>(
          onTap: favOnTap,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[const Text('Favorite'), AppIcons.star]),
        ),
        PopupMenuItem<dynamic>(
          onTap: editOnTap,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[const Text('Edit'), AppIcons.edit]),
        ),
        PopupMenuItem<dynamic>(
          onTap: commentOnTap,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[const Text('Add Comment'), AppIcons.add]),
        ),
        if (isExpenses)
          PopupMenuItem<dynamic>(
            onTap: moveToOnTap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Move to Savings'),
                  AppIcons.down,
                ]),
          )
        else
          PopupMenuItem<dynamic>(
            onTap: moveToOnTap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Move to Expenses'),
                  AppIcons.up,
                ]),
          ),
        PopupMenuItem<dynamic>(
          onTap: deleteOnTap,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[const Text('Delete'), AppIcons.delete]),
        ),
      ];

  static EdgeInsetsGeometry? pad16 = const EdgeInsets.all(16);

  static SizedBox width25 = const SizedBox(width: 25);
  static SizedBox height10 = const SizedBox(height: 10);
  static SizedBox height20 = const SizedBox(height: 20);
}
