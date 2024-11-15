import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/sleep_elements_provider.dart';
import 'package:night_gschallenge/providers/store_provider.dart';
import 'package:night_gschallenge/screens/forms/onboardingform/main-form.dart';
import 'package:night_gschallenge/screens/forms/sleepform/sleepForm.dart';
import 'package:night_gschallenge/screens/menu/PhoneFreeTime/phone_free_time.dart';
import 'package:night_gschallenge/screens/menu/SmartAlarm/smartalarm.dart';
import 'package:night_gschallenge/screens/startup/login_screen.dart';
import 'package:night_gschallenge/screens/startup/signup_screen.dart';
import 'package:night_gschallenge/screens/store/products_category.dart';
import 'package:night_gschallenge/widgets/UI/ListTileIconCreators.dart';
import 'package:night_gschallenge/widgets/UI/credits.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/loadingStateCreator.dart';
import 'package:night_gschallenge/widgets/home_screen/music_section.dart';
import 'package:night_gschallenge/widgets/home_screen/sleep_score.dart';
import 'package:night_gschallenge/widgets/home_screen/watch_component.dart';
import 'package:night_gschallenge/widgets/home_screen/welcome_user.dart';
import 'package:night_gschallenge/widgets/home_screen/sleep_stats.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool loading = true;
  bool once = true;
  bool? isSS;
  int sleepScore = 1;
  bool isWatchConnected = false;
  final calmData = {'title': 'Calm Tunes', 'tunes': [], 'buttonLink': '/Home'};

  final recents = {
    'title': 'Recents Added',
    'tunes': [],
    'buttonLink': '/Home'
  };

  final newsData = {
    'title': 'News Update',
    'news': ['a', 'b', 'c'],
    'buttonLink': '/Home'
  };

  Future data() async {
    await Provider.of<SleepElements>(context, listen: false).getSleepElements();

    isSS =
        Provider.of<SleepElements>(context, listen: false).isSleepScorePresent;

    if (isSS!) {
      sleepScore =
          Provider.of<SleepElements>(context, listen: false).sleepScore;
    }
    var id = FirebaseAuth.instance.currentUser?.uid;
    if (id != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) {
        if (value.exists) {
          isWatchConnected = value['isWatchConnected'];
        }
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvder = Provider.of<StoreProvder>(context, listen: false);
    var id = FirebaseAuth.instance.currentUser?.uid;
    if (once) {
      data();
      once = false;
    }
    return loading
        ? LoadingStateCreator()
        : SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const WelcomeUser(),
                isSS!
                    ? SleepScore(
                        sleepscore: sleepScore,
                      )
                    : Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 2,
                          ),
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (id == null) {
                              Navigator.of(context)
                                  .popAndPushNamed(SignupScreen.routeName);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(SleepForm.routeName);
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  (id != null)
                                      ? 'Generate your sleep score'
                                      : 'Sleep better, create an account now!',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                id == null
                    ? Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            HomeScreenText(
                              text: 'Start your journey',
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
                                color: Theme.of(context).splashColor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Theme.of(context).dividerColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://i.ibb.co/T21P53F/cloud.png",
                                        placeholder: (context, url) {
                                          return Image.asset(
                                            'assets/processloading.gif',
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return const Icon(Icons.error);
                                        },
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Trouble falling asleep?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: const Text(
                                      'Start your journey to better sleep. Let\'s create your sleep plan',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButtonWithoutIcon(
                                    onPressedButton: () {
                                      bool loginStatus =
                                          FirebaseAuth.instance.currentUser !=
                                              null;

                                      if (loginStatus) {
                                        Navigator.of(context)
                                            .pushNamed(MainForm.routeName);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showMaterialBanner(
                                          MaterialBanner(
                                            content: const Text(
                                              "You need to be signed in to get your plan!",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                              ),
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
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor,
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
                                          ScaffoldMessenger.of(context)
                                              .clearMaterialBanners();
                                        });
                                      }
                                    },
                                    text: 'Get your plan',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : const WhatsNew(),
                if (!isWatchConnected) const WatchComponent(),
                ListTileIconCreators(
                  onTap: () {
                    Navigator.of(context).pushNamed(SmartAlarm.routeName);
                  },
                  icon: Icons.emergency_recording_rounded,
                  title: "Record your daily snorings",
                ),
                const MusicSection(),
                ListTileIconCreators(
                  onTap: () {
                    Navigator.of(context).pushNamed(PhoneFreeTime.routeName);
                  },
                  icon: Icons.phone_disabled_sharp,
                  title: "Go Phone Free",
                ),
                ProductCategory(
                    data: storeProvder.getCategories[0]['items'],
                    type: storeProvder.getCategories[0]['type']),
                ListTileIconCreators(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Credits();
                      },
                    );
                  },
                  icon: Icons.apps,
                  title: "Thank you for using Shayan",
                ),
              ],
            ),
          );
  }
}
