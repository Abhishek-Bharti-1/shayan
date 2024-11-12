
import 'package:flutter/material.dart';
import 'package:night_gschallenge/screens/menu/TestMyBedroom/Noisepollution.dart';
import 'package:night_gschallenge/screens/menu/TestMyBedroom/light_pollution.dart';
import 'package:night_gschallenge/screens/menu/TestMyBedroom/temperature.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/tmb_description_cards.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';

class TestMyBedroom extends StatefulWidget {
  static String routeName = 'menu/testMyBedroom';

  const TestMyBedroom({super.key});

  @override
  State<TestMyBedroom> createState() => _TestMyBedroomState();
}

class _TestMyBedroomState extends State<TestMyBedroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const TopRow(back: true),
          HomeScreenText(text: 'Test My Bedroom'),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'We all need the perfect environment for sleep, light, noise and temperature are key elements in making your bedroom a relaxed and peaceful zone, perfectly suited for sleep',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Create your ideal sleep environment',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const TmbDescriptionCards(
            title: 'Light Pollution',
            subtitle:
                'Restricts the naturally timed rise of melatonin and delays the body\'s transition to sleep',
            image: 'https://i.ibb.co/xYnG0Tn/light.png',
            route: LightPollution.routeName,
          ),
          const TmbDescriptionCards(
            title: 'Noise Pollution',
            subtitle:
                'Restricts the naturally timed rise of melatonin and delays the body\'s transition to sleep',
            image: 'https://i.ibb.co/rsmgxyK/noise.png',
            route: NoisePollution.routeName,
          ),
          const TmbDescriptionCards(
            title: 'Temperature Check',
            subtitle:
                'Restricts the naturally timed rise of melatonin and delays the body\'s transition to sleep',
            image: 'https://i.ibb.co/9WZ2K07/temperature.png',
            route: Temperature.routeName,
          )
        ],
      ),
    );
  }
}
