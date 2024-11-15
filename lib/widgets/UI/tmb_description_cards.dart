import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/light_provider.dart';
import 'package:night_gschallenge/screens/menu/TestMyBedroom/light_pollution.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';
import 'package:provider/provider.dart';

class TmbDescriptionCards extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? image;
  final String? route;

  const TmbDescriptionCards({super.key, this.title, this.subtitle, this.image, this.route});

  @override
  Widget build(BuildContext context) {
    var widthi = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route!).then((value) {
          if (route == LightPollution.routeName) {
            var lightProvider =
                Provider.of<LightProvider>(context, listen: false);
            lightProvider.stopListening();
            lightProvider.success = false;
            lightProvider.state = false;
            lightProvider.data_points = [];
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Row(
            children: [
              Container(
                width: widthi * 0.5,
                padding: const EdgeInsets.only(left: 20, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ImageCacher(
                  imagePath: image,
                  isCanvas: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
