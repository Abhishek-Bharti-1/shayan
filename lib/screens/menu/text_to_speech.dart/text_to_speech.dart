import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/flutter_ttx.dart';
import 'package:night_gschallenge/screens/menu/text_to_speech.dart/drop_down_menu.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/slider_input.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';

class TextToSpeechComponent extends StatefulWidget {
  static String routeName = '/textToSpeech';
  final textController = TextEditingController();
  List<Object?> voicesMap = [];
  String dropDown = "Microsoft David - English (United States)";
  int modalIndex;
  double volume;
  double rate;
  double pitch;
  List<String> modals = ['Volume', 'Pitch', 'Rate'];
  List<String> options = ['Speak', 'Resume', 'Pause', 'Stop'];
  TextToSpeechComponent({super.key, 
    this.modalIndex = -1,
    this.volume = 0.5,
    this.rate = 1,
    this.pitch = 1,
  });

  @override
  State<TextToSpeechComponent> createState() => _TextToSpeechComponentState();
}

class _TextToSpeechComponentState extends State<TextToSpeechComponent> {
  @override
  void initState() {
    super.initState();
    // if(Platform.isAndroid)
    VolumeController().listener((volume) {
      widget.volume = volume;
    });
  }

  @override
  void dispose() {
    // if(Platform.isAndroid)
    VolumeController().removeListener();
    super.dispose();
  }

  double getValue() {
    if (widget.modalIndex == 0) {
      return widget.volume;
    } else if (widget.modalIndex == 1) {
      return widget.pitch;
    }
    return widget.rate;
  }

  @override
  Widget build(BuildContext context) {
    var textSpeech = Provider.of<FlutterTextSpeech>(context);
    return Scaffold(
      body: ListView(
        children: [
          const TopRow(back: true),
          Container(
            child: Column(
              children: [
                HomeScreenText(
                  text: 'Listen to your Stories',
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              minLines: 8,
                              autocorrect: false,
                              maxLines: 15,
                              controller: widget.textController,
                              decoration: InputDecoration(
                                hintText: 'Enter Text For Speech',
                                hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                fillColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.modalIndex = 0;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.volume_down,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.modalIndex = 1;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_voice_sharp,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.modalIndex = 2;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.fast_forward,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: FutureBuilder(
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          widget.voicesMap = [
                                            {'name': 'Select Language'}
                                          ];
                                        } else {
                                          widget.voicesMap = snapshot.data;
                                        }
                                        return DropDownMenu(widget.voicesMap);
                                      },
                                      future: Provider.of<FlutterTextSpeech>(
                                              context)
                                          .getVoices(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.modalIndex != -1)
                        SliderInput(
                          value: getValue(),
                          title: widget.modals[widget.modalIndex],
                          callback: (double value) {
                            if (widget.modals[widget.modalIndex] == 'Volume') {
                              widget.volume = value;
                              VolumeController().setVolume(value);
                              textSpeech.setVolume(value);
                            } else if (widget.modals[widget.modalIndex] ==
                                'Rate') {
                              widget.rate = value;
                              textSpeech.setRate(value);
                            } else {
                              widget.pitch = value;
                              textSpeech.setPitch(value);
                            }
                          },
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          height: 400,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 8 / 2,
                                    mainAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (widget.options[index] == 'Speak') {
                                    textSpeech
                                        .setText(widget.textController.text);
                                    textSpeech.speak();
                                  } else if (widget.options[index] ==
                                      'Resume') {
                                    textSpeech.speak();
                                  } else if (widget.options[index] == 'Stop') {
                                    textSpeech.stop();
                                  } else {
                                    textSpeech.pause();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    widget.options[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              );
                            },
                            itemCount: 4,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
