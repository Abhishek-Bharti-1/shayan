import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/flutter_ttx.dart';
import 'package:provider/provider.dart';

class DropDownMenu extends StatefulWidget {
  String dropDown ='';
  List<dynamic> voices =[];
  DropDownMenu(voices, {super.key}){
    this.voices=voices;
    dropDown = voices[0]['name'];
  }
  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    var textSpeech = Provider.of<FlutterTextSpeech>(context);
    return DropdownButton<String>(
          dropdownColor: Theme.of(context).primaryColor,
          items: widget.voices
              .map<DropdownMenuItem<String>>((ele) => DropdownMenuItem<String>(
                    value: ele['name'] ,
                    key: Key(ele['name']),
                    child: Text(ele['name'],
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          isExpanded: true,
          hint: const Text('Select voice', overflow: TextOverflow.ellipsis),
          value: widget.dropDown,
          onChanged: (String? value) {
            setState(() {
              textSpeech.setVoice(widget.voices, value);
              widget.dropDown = value!;
            });
          },
    );
  }
}
