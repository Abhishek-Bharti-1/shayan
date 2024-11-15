import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/audio_provider.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';

class MusicTherapyModal extends StatefulWidget {
  Map<dynamic, dynamic> therapy = {};
  bool isPlaying = false;
  AudioProvider audioProvider;
  MusicTherapyModal(this.therapy, this.audioProvider, {super.key});

  @override
  State<MusicTherapyModal> createState() => _MusicTherapyModalState();
}

class _MusicTherapyModalState extends State<MusicTherapyModal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                if (widget.isPlaying) {
                  widget.audioProvider.stop();
                }
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 150,
            child: ImageCacher(
              imagePath: widget.therapy['image'],
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.therapy['mood'],
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  widget.therapy['tunes'][0]['title'],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                trailing: CircleAvatar(
                  child: IconButton(
                    icon: Icon(widget.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow_rounded),
                    onPressed: () {
                      if (!widget.isPlaying) {
                        widget.audioProvider.play();
                      } else {
                        widget.audioProvider.stop();
                      }
                      setState(() {
                        widget.isPlaying = !widget.isPlaying;
                      });
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
