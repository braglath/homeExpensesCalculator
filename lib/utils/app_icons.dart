import 'package:flutter/material.dart';

class AppIcons {
  factory AppIcons() => _appIcons;
  AppIcons._internal();
  static final AppIcons _appIcons = AppIcons._internal();

  static Icon get date => const Icon(Icons.date_range);
  static Icon get add => const Icon(Icons.add);
  static Icon get list => const Icon(Icons.list);
  static Icon get up => const Icon(Icons.arrow_upward);
  static Icon get down => const Icon(Icons.arrow_downward);
  static Icon get star => const Icon(Icons.star);
  static Icon get delete => const Icon(Icons.delete);
  static Icon get edit => const Icon(Icons.edit);
  static Icon get editGrey300 => Icon(
        Icons.edit,
        color: Colors.grey[300],
        size: 18,
      );
}
