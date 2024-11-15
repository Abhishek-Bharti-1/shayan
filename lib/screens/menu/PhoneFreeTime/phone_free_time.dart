import 'package:flutter/material.dart';
import 'package:night_gschallenge/screens/menu/PhoneFreeTime/time_duration_picker.dart';
import 'package:night_gschallenge/screens/menu/PhoneFreeTime/zen_screen.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';

class PhoneFreeTime extends StatelessWidget {
  static String routeName = '/phone-free-time';
  List<String> info = [
    "Mode can not be exited once started",
    "Incoming notifications will be temporarily muted",
    "You can still answer phone calls and make emergency phone calls",
    "All apps will be temporarily locked except the camera",
  ];
  int duration = 0;

  PhoneFreeTime({super.key});
  void callbackSetDuration(String time) {
    duration = int.parse(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const TopRow(
            back: true,
          ),
          HomeScreenText(
            text: "Phone Free Time",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: const EdgeInsets.all(30),
              child: Column(children: [
                const Text(
                  'Before You Start',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                ...info.map((element) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              'assets/check-mark.png',
                              fit: BoxFit.cover,
                            )),
                        Expanded(
                            child: Text(
                          element,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ))
                      ],
                    ),
                  );
                }).toList(),
              ]),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.48,
                height: 140,
                child: ImageCacher(
                  imagePath: "https://i.ibb.co/nBG0tRP/phone-free-time.gif",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.52,
                height: 140,
                alignment: Alignment.center,
                child: TimeDurationPicker(callbackSetDuration),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButtonWithoutIcon(
              onPressedButton: () {
                Navigator.of(context)
                    .pushNamed(ZenScreen.routeName, arguments: duration);
              },
              text: 'Start',
            ),
          ),
        ],
      ),
    );
  }
}
