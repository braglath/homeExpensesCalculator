import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  const CommonElevatedButton({
    required this.text,
    required this.onTap,
    this.color,
    super.key,
  });
  final Color? color;
  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) => Expanded(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: onTap,
          child: Text(text)));
}
