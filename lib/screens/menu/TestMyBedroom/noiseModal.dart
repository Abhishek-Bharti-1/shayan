import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/noise_provider.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:provider/provider.dart';

class NoiseModal extends StatelessWidget {
  const NoiseModal({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<NoiseProvider>(context).dataValue;
    var height = MediaQuery.of(context).size.height;
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: height / 8,
                child: ImageCacher(imagePath:data['image']!),
              ),
              Text(
                data['heading']!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                data['subheading']!,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButtonWithoutIcon(
                text: 'Close',
                onPressedButton: () {
                  Provider.of<NoiseProvider>(context, listen: false)
                      .stopRecorder();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
