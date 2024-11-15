import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/audio_provider.dart';
import 'package:night_gschallenge/widgets/UI/music_player.dart';
import 'package:night_gschallenge/widgets/UI/sliding_card_rounded.dart';
import 'package:provider/provider.dart';

class MusicCategory extends StatelessWidget {
  List<Map<dynamic, dynamic>> data;
  String title;
  MusicCategory({super.key, required this.data, required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(
          height: 380,
          width: MediaQuery.of(context).size.width - 20,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              ...data.map((e) {
                int index = data.indexOf(e);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(MusicPlayer.routeName,
                        arguments: {
                          'playlist': data,
                          'index': index
                        }).then((va) async {
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                      await Provider.of<AudioProvider>(context, listen: false).release();
                    });
                  },
                  child: Container(
                    width: 250,
                    height: 380,
                    margin: const EdgeInsets.all(10),
                    child: SlidingCardRounded(
                      heading: e['title'],
                      subHeading: e['description'],
                      src: e['image'],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
