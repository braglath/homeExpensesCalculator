import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/utils/app_constants.dart';

class ContextMenu {
  static Future<void> showServicesContextMenu(
    BuildContext context, {
    required Offset offset,
    required Function()? favOnTap,
    required Function()? editOnTap,
    required Function()? commentOnTap,
    required Function()? deleteOnTap,
    required Function()? moveToOnTap,
    bool isExpenses = false,
  }) async {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;
    await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            offset & const Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay.size // Bigger rect, the entire screen
            ),
        items: AppConstants.servicesContextMenu(
            favOnTap: favOnTap,
            editOnTap: editOnTap,
            commentOnTap: commentOnTap,
            deleteOnTap: deleteOnTap,
            isExpenses: isExpenses,
            moveToOnTap: moveToOnTap));
  }
}
