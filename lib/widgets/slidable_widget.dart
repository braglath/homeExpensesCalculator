import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableWidget extends StatelessWidget {
  const SlidableWidget({
    required this.leftBtnOnPressed,
    required this.rightBtnOnPressed,
    required this.child,
    super.key,
  });
  final Function(BuildContext)? leftBtnOnPressed;
  final Function(BuildContext)? rightBtnOnPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) => Slidable(
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: <Widget>[
            const Flexible(flex: 1, child: SizedBox(width: 10)),
            SlidableAction(
              // An action can be bigger than the others.
              flex: 2,
              onPressed: leftBtnOnPressed,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              flex: 2,
              onPressed: rightBtnOnPressed,
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: child,
      );
}
