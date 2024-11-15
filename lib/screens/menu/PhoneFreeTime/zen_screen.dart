import 'package:flutter/material.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:night_gschallenge/providers/count_down_provider.dart';
import 'package:night_gschallenge/providers/screen_brightness_provider.dart';
import 'package:night_gschallenge/screens/menu/MentalExercise/mental_exercise.dart';
import 'package:night_gschallenge/screens/menu/PhoneFreeTime/phone_free_time.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

class ZenScreen extends StatefulWidget {
  static String routeName = '/zen-screen';
  double currBrightness = 0;

  ZenScreen({super.key});
  @override
  State<ZenScreen> createState() => _ZenScreenState();
}

class _ZenScreenState extends State<ZenScreen> {
  @override
  Widget build(BuildContext context) {
    var brightnessProvider =
        Provider.of<ScreenBrightnessProvider>(context, listen: false);
    brightnessProvider.currentBrightness
        .then((value) => widget.currBrightness = value);
    brightnessProvider.setBrightness(0);
    VolumeController().setVolume(0);
    final args = ModalRoute.of(context)!.settings.arguments;
    var controller = Provider.of<CountDownProvider>(context).controller;
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('You are in Zen Mode Wait for '),
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                VolumeController().setVolume(100);
                brightnessProvider
                    .setBrightness(widget.currBrightness)
                    .then((value) {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(PhoneFreeTime.routeName));
                });
              },
              child: const Text(
                'Exit Mode',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )),
          ],
        )));
        return false;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeonCircularTimer(
              onComplete: () {
                brightnessProvider.resetBrightness();
                VolumeController().setVolume(100);
                Navigator.of(context).pop();
              },
              controller: controller,
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 37,
                  color: Theme.of(context).primaryColor),
              isTimerTextShown: true,
              neumorphicEffect: true,
              duration: (args as int) * 60,
              innerFillGradient: LinearGradient(colors: [
                const Color.fromRGBO(255, 255, 255, 1),
                Theme.of(context).canvasColor
              ]),
              backgroudColor: Theme.of(context).secondaryHeaderColor,
              neonGradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(255, 255, 255, 1),
                  Theme.of(context).canvasColor
                ],
              ),
              width: 250,
            ),
            const SizedBox(height: 20,),
            ElevatedButtonWithoutIcon(text: "Can't Sleep?",onPressedButton: (){
              brightnessProvider.resetBrightness();
              VolumeController().setVolume(100);
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MentalExercise.routeName);
            },)
          ],
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
