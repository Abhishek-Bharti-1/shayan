import 'package:flutter/material.dart';

class MeasuringTemperature extends StatelessWidget {
  const MeasuringTemperature({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Center(
            child: Text(
              'Please wait while we fetch the details for you...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
