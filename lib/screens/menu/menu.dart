import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final String text;
  final String imagePath;
  const Menu({super.key, required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardColor,
            Theme.of(context).hoverColor,
          ],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 1,
              minHeight: 1,
            ),
            child: Image.asset(
              imagePath,
            )
          ),
        ],
      ),
    );
  }
}
