import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:night_gschallenge/screens/startup/login_screen.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:night_gschallenge/widgets/home_screen/watch_modal.dart';

class WatchComponent extends StatefulWidget {
  const WatchComponent({super.key});

  @override
  State<WatchComponent> createState() => _WatchComponentState();
}

class _WatchComponentState extends State<WatchComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          HomeScreenText(
            text: 'Connect your device',
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: ImageCacher(
                    imagePath: "https://i.ibb.co/yRCc7vC/watch.gif",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Make Sleep Tracking Simple',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Let\'s get your wearable connected. With a little bit of magic, your sleep data will automatically be pulled into your sleep tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButtonWithoutIcon(
                  onPressedButton: () {
                    bool loginStatus =
                        FirebaseAuth.instance.currentUser != null;

                    if (loginStatus) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: const Scaffold(body: WatchModal()),
                            ),
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: const Text(
                            "You need to be signed in to fetch data from your watch.",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .clearMaterialBanners();
                              },
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                      Navigator.of(context)
                          .pushNamed(LoginScreen.routeName)
                          .then((value) {
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                      });
                    }
                  },
                  text: 'Fetch data from your watch',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
