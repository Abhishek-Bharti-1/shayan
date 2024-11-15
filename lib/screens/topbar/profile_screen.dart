import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/shared_preferences_provider.dart';
import 'package:night_gschallenge/providers/watch_provider.dart';
import 'package:night_gschallenge/screens/home/home_screen.dart';
import 'package:night_gschallenge/screens/startup/default_night_screen.dart';
import 'package:night_gschallenge/screens/startup/splash_screen.dart';
import 'package:night_gschallenge/widgets/UI/ListTileIconCreators.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatelessWidget {
  String attribute, value;
  ProfileInfo(this.attribute, this.value, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            attribute,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
          ),
          child: const Text(""),
        )
      ]),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String theme = "";

  var currentUser = FirebaseAuth.instance.currentUser;
  String version = "v1.0";

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<sharedPreferencesProvider>(context)
          .getValue('launch', 'mode')
          .toString();

    print(theme);
    Map<String, dynamic> profile = {
      "Name": FirebaseAuth.instance.currentUser?.displayName,
      "Email ID": FirebaseAuth.instance.currentUser?.email,
      "Verification Status":
          FirebaseAuth.instance.currentUser?.emailVerified.toString() == "true"
              ? "Successfully Verified"
              : "Not Verified",
      "Default Theme": theme == 'light' ? "Light Mode" : theme=="" ? "Not Set" : "Dark Mode" 
    };
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Positioned(
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(800),
                          bottomRight: Radius.circular(800))),
                  child: const Text(""),
                ),
              ),
              const TopRow(
                back: true,
                profile: false,
              ),
              Positioned(
                top: 10,
                left: MediaQuery.of(context).size.width / 2 - 90,
                child: Container(
                  child: Icon(
                    Icons.person_outline_sharp,
                    color: Theme.of(context).iconTheme.color,
                    size: 170,
                  ),
                ),
              )
            ],
          ),
          if (currentUser == null)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Please Login/SignUp",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButtonWithoutIcon(
                    text: "Login",
                    onPressedButton: () {
                      Navigator.of(context).popUntil(
                        (route) => route == "",
                      );
                      Navigator.of(context).pushNamed(SplashScreen.routeName);
                    },
                  )
                ],
              ),
            ),
          if (currentUser != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...profile.entries.map((e) {
                  return ProfileInfo(
                    e.key,
                    e.value,
                  );
                }).toList(),
                ListTileIconCreators(
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Provider.of<sharedPreferencesProvider>(context,
                            listen: false)
                        .clear();
                    Navigator.of(context).popUntil((route) => route == "");
                    Navigator.of(context).pushNamed(SplashScreen.routeName);
                  },
                )
              ],
            ),
          if (currentUser != null)
            ListTileIconCreators(
              title: 'Revoke Google Fit ID',
              onTap: () async {
                await Provider.of<WatchDataProvider>(context, listen: false)
                    .revoke();

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser?.uid)
                    .update({
                  'isWatchConnected': false,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your account is successfully reset"),
                  ),
                );
              },
              icon: Icons.signal_cellular_no_sim_sharp,
            ),
          if (currentUser != null &&
              !FirebaseAuth.instance.currentUser!.emailVerified)
            ListTileIconCreators(
              title: 'Verify your email',
              onTap: () async {
                FirebaseAuth.instance.currentUser?.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Email sent. Please check your spam folder."),
                  ),
                );
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamed(HomeScreen.routeName);
              },
              icon: Icons.email,
            ),
          ListTileIconCreators(
            title: 'Set Default Theme',
            onTap: () async {
              Navigator.of(context).pushNamed(DefaultNightScreen.routeName);
            },
            icon: Icons.calendar_view_week_sharp,
          ),
        ],
      ),
    );
  }
}
