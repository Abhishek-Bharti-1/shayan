import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/location_provider.dart';
import 'package:night_gschallenge/providers/weather_provider.dart';
import 'package:night_gschallenge/screens/menu/TestMyBedroom/Measuring_temperature.dart';
import 'package:night_gschallenge/screens/menu/TestMyBedroom/temperatureModal.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:night_gschallenge/widgets/UI/loadingStateCreator.dart';
import 'package:night_gschallenge/widgets/UI/permissionModal.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Temperature extends StatefulWidget {
  static const routeName = 'menu/temperature';

  const Temperature({super.key});

  @override
  _TemperatureState createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool state = false;
  bool loading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool scrolled = false;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        controller: _scrollController,
        children: [
          const TopRow(
            back: true,
          ),
          HomeScreenText(text: 'Temperature'),

          Container(
            margin: const EdgeInsets.all(40),
            height: 200,
            child: ImageCacher(
              imagePath: "https://i.ibb.co/PNYhNrQ/temperatures.gif",
              fit: BoxFit.contain,
            ),
          ),

          // Informative Text
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_circle_rounded, size: 30),
                const SizedBox(
                  width: 10,
                ),
                SizedBox( 
                  width: (width - 40) * 0.9,
                  child: Text(
                    'The ideal temperature for sleep is 18-22C. Make sure to adjust your AC accordingly,wear suitable pjamas and cover yourself with right blanket.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          if (!state)
            loading ? Center(child: LoadingStateCreator()) : Center(
              child: ElevatedButtonWithoutIcon(
                text: "Fetch Temperature",
                onPressedButton: () async {
                  if (state == true) {
                    null;
                  } else {
                    var permit = await Permission.location.status;

                    if (permit == PermissionStatus.permanentlyDenied) {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return PermissionModal(
                            permissionName: 'Location',
                            icon: Icons.location_off,
                          );
                        },
                      );
                    } else if (permit == PermissionStatus.granted)  {
                      setState(() {
                        loading = true;
                      });
                      await Provider.of<LocationProvider>(context, listen: false).initPlatformState();
                      setState(() {
                        loading = false;
                      });
                      double latitude =  Provider.of<LocationProvider>(context, listen: false).latitude;
                      double longitude = Provider.of<LocationProvider>(context, listen: false).longitude;

                      await Provider.of<WeatherProvider>(context, listen: false)
                          .getWeather(latitude, longitude);
                      setState(() {
                        state = true;
                      });
                    } else {
                      await Permission.location.request();
                    }
                  }
                },
              ),
            ),

          Consumer<WeatherProvider>(
            builder: (context, value, child) {
              if (value.state && !value.success) {
                var height = MediaQuery.of(context).size.height;
                if(!scrolled){
                  _scrollController.animateTo(height, duration: const Duration(seconds: 1), curve: Curves.linear);
                  scrolled = true;
                }
                return const MeasuringTemperature();
              } else if (value.success == true && value.state == false) {
                return Center(
                  child: ElevatedButtonWithoutIcon(
                    onPressedButton: () {
                      setState(() {
                        state = false;
                      });
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return const TemperatureModal();
                        },
                      );
                    },
                    text: 'Results',
                  ),
                );
              } else {
                return const Card();
              }
            },
          )
        ],
      ),
    );
  }
}
