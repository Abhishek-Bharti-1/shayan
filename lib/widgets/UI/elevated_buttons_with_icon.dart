import 'package:flutter/material.dart';

class ElevatedButtonsWithIcon extends StatelessWidget {
  void Function()? onPressed;
  final String? title;
  final IconData? icon;

  ElevatedButtonsWithIcon({super.key, this.onPressed, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [Icon(icon), Text(title!)],
        ),
      ),
    );
  }
}
