import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:night_gschallenge/widgets/UI/loadingStateCreator.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';
import 'package:url_launcher/url_launcher.dart';

class SleepDietSuggestion extends StatelessWidget {
  static String routeName = '/sleep-diet-suggestion';

  const SleepDietSuggestion({super.key});
  List<Widget> dietArticle(BuildContext context, List<dynamic> list) {
    return [
      Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          'Related Articles',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      Column(
        children: list.map((e) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Text(e['description'].toString()),
              ),
              IconButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(e['link'].toString()),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: Icon(
                  Icons.insert_link_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              const SizedBox(
                width: 2,
              )
            ],
          );
        }).toList(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const TopRow(
              back: true,
            ),
            HomeScreenText(
              text: "Sleep Diet Suggestion",
            ),
            Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: ImageCacher(
                imagePath: "https://i.ibb.co/v38qMq2/sleep-diet-suggestion.gif",
                fit: BoxFit.cover,
              ),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingStateCreator(),
                  );
                }
                if (snapshot.data!.exists &&
                    snapshot.data?.get('diseaseType') == 'sleep deprivation') {
                  return FutureBuilder(
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: LoadingStateCreator(),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            DietWindow(snapshot.data?.data()!['tips']),
                            ...dietArticle(
                                context, snapshot.data?.data()!['tips'])
                          ],
                        ),
                      );
                    },
                    future: FirebaseFirestore.instance
                        .collection('diet_suggestion')
                        .doc("sleep deprivation")
                        .get(),
                  );
                }
                if (snapshot.data!.exists &&
                    snapshot.data?.get('diseaseType') == 'apnea') {
                  return FutureBuilder(
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: LoadingStateCreator(),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            DietWindow(
                              snapshot.data?.data()!['tips'],
                            ),
                            ...dietArticle(
                              context,
                              snapshot.data?.data()!['tips'],
                            )
                          ],
                        ),
                      );
                    },
                    future: FirebaseFirestore.instance
                        .collection('diet_suggestion')
                        .doc("apnea")
                        .get(),
                  );
                }
                if (snapshot.data!.exists &&
                    snapshot.data?.get('diseaseType') == 'isnsomia') {
                  return FutureBuilder(
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: LoadingStateCreator(),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            DietWindow(
                              snapshot.data?.data()!['tips'],
                            ),
                            ...dietArticle(
                              context,
                              snapshot.data?.data()!['tips'],
                            )
                          ],
                        ),
                      );
                    },
                    future: FirebaseFirestore.instance
                        .collection('diet_suggestion')
                        .doc("isnsomia")
                        .get(),
                  );
                }

                return FutureBuilder(
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: LoadingStateCreator(),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          DietWindow(
                            snapshot.data?.data()!['tips'],
                          ),
                          ...dietArticle(
                            context,
                            snapshot.data?.data()!['tips'],
                          )
                        ],
                      ),
                    );
                  },
                  future: FirebaseFirestore.instance
                      .collection('diet_suggestion')
                      .doc("healthy")
                      .get(),
                );
              },
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
            )
          ],
        ),
      ),
    );
  }
}

class DietWindow extends StatelessWidget {
  List<dynamic> suggestions;
  DietWindow(this.suggestions, {super.key});
  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Column(
        children: suggestions.map((e) {
      i++;
      return Row(
        mainAxisAlignment:
            i % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(13),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Text(e['description'] as String),
          ),
        ],
      );
    }).toList());
  }
}
