import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/audio_provider.dart';
import 'package:night_gschallenge/screens/menu/MentalExercise/mental_exercise_solutions.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:night_gschallenge/widgets/UI/menuHeroImage.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';
import 'package:provider/provider.dart';

class MentalExercise extends StatelessWidget {
  List<Map<String, String>> options = [
    {
      'title': 'Visualization',
      'subtitle':
          'Involves creating a mental image or scenario that is soothing, calming, and peaceful',
      "image": 'https://i.ibb.co/fnK1H0N/visualization.png',
    },
    {
      'title': 'Progressive Muscle Relaxation',
      'subtitle': 'It makes user more aware of areas of tension in their body',
      "image": 'https://i.ibb.co/y00Jr5V/relaxation.png',
    },
    {
      'title': 'Meditation',
      'subtitle':
          'Mental practice that involves focusing the mind on a particular object',
      "image": 'https://i.ibb.co/wdF7MXq/meditation.png',
    },
    {
      'title': 'Autogenic Relaxation',
      'subtitle':
          'Using self-suggestion to create a sense of relaxation and well-being in the body',
      "image": 'https://i.ibb.co/1rcxjYg/autogenic-relaxation.png',
    },
    {
      'title': 'Deep Breathing',
      'subtitle':
          'Relaxation technique that involves taking slow, deep breaths',
      "image": 'https://i.ibb.co/PNt6zmD/deep-breathing.png',
    },
  ];
  static String routeName = '/mental-exercise';

  MentalExercise({super.key});
  @override
  Widget build(BuildContext context) {
    var widthi = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(children: [
        const TopRow(
          back: true,
        ),
        HomeScreenText(
          text: "Mental Exercises",
        ),
        MenuHeroImage(
          image: 'https://i.ibb.co/1MJHrk7/mental-Exercises.gif',
        ),
        Container(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    ...options.map((card) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(
                            MentalExerciseSolution.routeName,
                            arguments: card['title'],
                          )
                              .then((value) {
                            dynamic player = Provider.of<AudioProvider>(context,
                                listen: false);
                            if (player.duration.inMilliseconds > 0) {
                              player.release();
                            }
                          });
                        },
                        child: Container(
                          height: 185,
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                              width: 2,
                            ),
                          ),
                          width: double.infinity,
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Container(
                                width: widthi * 0.5,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     SizedBox(
                                        height: 28,
                                        child: Text(
                                          card['title'].toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                              overflow: TextOverflow.clip,
                                        ),
                                    
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        card['subtitle'].toString(),
                                        overflow: TextOverflow.clip,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ImageCacher(
                                  imagePath: card['image'].toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
