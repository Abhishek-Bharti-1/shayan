import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:night_gschallenge/providers/timeline_provider.dart';
import 'package:night_gschallenge/screens/plan/addEdit_timeline.dart';
import 'package:night_gschallenge/screens/plan/timeline_card.dart';
import 'package:night_gschallenge/screens/startup/splash_screen.dart';
import 'package:night_gschallenge/widgets/UI/ListTileIconCreators.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/screens/forms/onboardingform/main-form.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:night_gschallenge/widgets/UI/loadingStateCreator.dart';
import 'package:night_gschallenge/widgets/UI/menuHeroImage.dart';
import 'package:night_gschallenge/widgets/sleep_screen/sleep_report_analysis.dart';
import '../../widgets/UI/home_screen_heading.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatefulWidget {
  static const routeName = '/plan';

  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool showPlan = false;

  Duration isActiveCheck(String str) {
    var format = DateFormat("HH:mm");
    var first = format.parse(str);
    var now = DateTime.now();
    var second = format.parse("${now.hour}:${now.minute}");
    return first.difference(second);
  }

  bool once = true;
  bool loading = false;
  int questionNumber = 32;
  var id = FirebaseAuth.instance.currentUser?.uid;

  void getQuestion() async {
    once = false;
    loading = true;

    try {
      var data =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      questionNumber = 34 - data['questionNumber'] as int;
    } catch (err) {
      print(err.toString());
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var timelineProvider = Provider.of<TimelineProvider>(context);
    return FirebaseAuth.instance.currentUser == null
        ? ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreenText(
                text: 'Plan Screen',
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Theme.of(context).canvasColor,
                ),
                child: Column(
                  children: [
                    MenuHeroImage(
                      image: 'https://i.ibb.co/Rz4fRdz/mantra-2.png',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Create your own personalised plan for managing your sleep',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButtonWithoutIcon(
                        text: id != null ? 'Create a plan' : 'Login to proceed',
                        onPressedButton: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            SplashScreen.routeName,
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                if (once) getQuestion();
                return Center(
                  child: LoadingStateCreator(),
                );
              }

              if (snapshot.data?.get('healthState') == 'NA') {
                return Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Text(
                        'We need your help to create a plan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ImageCacher(
                          imagePath: 'https://i.ibb.co/NKVXXvS/checklist.png'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Please complete a questionnaire so that we can create your personalized plan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      ElevatedButtonWithoutIcon(
                        text: 'Start',
                        onPressedButton: () =>
                            Navigator.of(context).pushNamed(MainForm.routeName),
                      )
                    ],
                  ),
                );
              } else if (snapshot.data?.get('healthState') == 'true' &&
                  snapshot.data?.get('isReady') == 'true') {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      HomeScreenText(
                        text: "My Plan",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      enableDrag: true,
                                      builder: (context) {
                                        return SingleChildScrollView(
                                            child: AddEditTimeline(-1));
                                      },
                                      backgroundColor:
                                          Theme.of(context).primaryColor);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 34,
                                ),
                              )
                            ],
                          ),
                          FutureBuilder(
                            future: timelineProvider.fetchTimeline(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return LoadingStateCreator();
                              }
                              var timeline = snapshot.data;

                              return Column(
                                children: [
                                  ...timeline
                                      .map((e) {
                                        var difference =
                                            isActiveCheck(e['time']);
                                        int index = timeline.indexOf(e);
                                        if (difference
                                                .compareTo(Duration.zero) >=
                                            0) {
                                          return e['suggestion'] != null
                                              ? TimelineCard(
                                                  index: index,
                                                  duration:
                                                      difference.toString(),
                                                  isActive: index == 0,
                                                  task: e['task'],
                                                  time: e['time'],
                                                  suggestion: e['suggestion'],
                                                )
                                              : TimelineCard(
                                                  index: index,
                                                  duration:
                                                      difference.toString(),
                                                  isActive: index == 0,
                                                  task: e['task'],
                                                  time: e['time'],
                                                );
                                        } else{

                                          return null;
                                        }
                                      })
                                      .toList()
                                      .where((element) => element != null)
                                      .toList()
                                ],
                              );
                            },
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTileIconCreators(
                                    title: 'Fetch your sleep report again',
                                    icon: Icons.search,
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(id)
                                          .update({
                                        'questionNumber': -1,
                                      });
                                      Navigator.of(context)
                                          .pushNamed(MainForm.routeName);
                                    }),
                                ListTileIconCreators(
                                  title: 'Check out your latest sleep report',
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: true,
                                      builder: (context) {
                                        return SleepReportAnalysis();
                                      },
                                    );
                                  },
                                  icon: Icons.change_circle,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.data?.get('healthState') == 'true') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HomeScreenText(
                      text: "My Plan",
                    ),
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: ImageCacher(
                        imagePath: "https://i.ibb.co/DwZKcy4/my-plan.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        'Let\'s make your dream weaver plan',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: const Text(
                        "Craft your perfect sleep with a personalized timeline.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        shrinkWrap: true,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.timeline_rounded,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: const Text(
                                  "Personalized Dynamic Timeline",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(Icons.youtube_searched_for,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 40),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: const Text(
                                  "Enriching Sleep Education Content",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(Icons.chat_rounded,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 40),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: const Text(
                                  "Chat with a Sleep Trainer",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(Icons.timer_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 40),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: const Text(
                                  "Rightly Timed Reminders",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButtonWithoutIcon(
                          onPressedButton: () async {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .update({'isReady': 'true'});
                            setState(() {
                              showPlan = !showPlan;
                            });
                          },
                          text: "I'm ready"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else if (snapshot.data?.get('healthState') == 'false') {
                return Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      HomeScreenText(
                        text: "My Plan",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Text(
                                '$questionNumber Questions left!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Let\'s optimize your sleep experience',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).secondaryHeaderColor,
                            fontFamily: 'Roboto'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Give us insights into your sleep, lifestyle and daily behaviors and we\'ll create a personalized plan that suits your needs.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).secondaryHeaderColor,
                            fontFamily: 'Roboto'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButtonWithoutIcon(
                        text: 'Complete Questionnaire',
                        onPressedButton: () =>
                            Navigator.of(context).pushNamed(MainForm.routeName),
                      )
                    ],
                  ),
                );
              }
              return const AlertDialog(
                title: Text('An error occurred!'),
              );
            },
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get(),
          );
  }
}
