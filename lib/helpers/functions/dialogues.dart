import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/helpers/extensions/ext_on_context.dart';

class Dialogue {
  static Future<void> showAlertDialogue(
    BuildContext context, {
    required String title,
    required Widget mainContent,
    String cancelBtnTitle = "Cancel",
    String actionBtnTitle = "Okay",
    Function(BuildContext)? onCancel,
    Function(BuildContext)? onAction,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) => AlertDialog(
          title: Text(title),
          content: mainContent,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (onCancel == null) {
                  ctx.pop();
                } else {
                  onCancel(ctx);
                }
              },
              child: Text(cancelBtnTitle),
            ),
            TextButton(
              onPressed: () {
                if (onAction == null) {
                  ctx.pop();
                } else {
                  onAction(ctx);
                }
              },
              child: Text(actionBtnTitle),
            ),
          ],
        ),
      );
}
