import 'package:flutter/material.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';

class SleepScoreCard extends StatelessWidget {
  final String? text;
  final int? sleepscore;

  const SleepScoreCard({super.key, 
    this.text = "To maintain optimal performance, you may require more rest",
    this.sleepscore = 89,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: (width - 20) * 0.70,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).canvasColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(300),
                      ),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      sleepscore.toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(text!),
                )
              ],
            ),
          ),
          Expanded(
            child: ImageCacher(
              imagePath: 'https://i.ibb.co/BTCSgLs/kid.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
