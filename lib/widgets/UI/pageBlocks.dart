import 'package:flutter/material.dart';

class PageBlocks extends StatelessWidget {
  void Function()? onTap;
  String? title;
  String? image;
  PageBlocks({super.key, this.onTap, this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    title!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                subtitle: const Text(
                  "Connect with a supportive community of sleep enthusiasts, where you can share experiences, exchange tips, and find encouragement on your path to better sleep.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                trailing: const Text("")
            )
          ),
        ),
      ),
    );
  }
}
