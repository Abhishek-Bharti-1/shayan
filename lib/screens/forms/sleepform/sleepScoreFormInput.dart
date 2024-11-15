import 'package:flutter/material.dart';
import 'package:night_gschallenge/screens/forms/onboardingform/main-form.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class SleepScoreFormInput extends StatefulWidget {
  String keya;
  String? question;
  InputTypes? type;
  Function? onSubmit;
  Function? value;
  TimeOfDay? initialValue;
  int? initialText;

  SleepScoreFormInput({super.key, 
    this.keya = '2',
    this.question,
    this.type,
    this.onSubmit,
    this.value,
    this.initialValue,
    this.initialText,
  });

  @override
  State<SleepScoreFormInput> createState() => _SleepScoreFormInputState();
}

class _SleepScoreFormInputState extends State<SleepScoreFormInput> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    num? something = widget.initialValue?.hour ?? -1;
    String? hour = something != -1
        ? something > 12
            ? (something - 12).toString()
            : widget.initialValue?.hour.toString()
        : '';
    String? minutes =
        something != -1 ? widget.initialValue?.minute.toString() ?? '' : '';
    String? mode = something != -1
        ? something > 12
            ? 'PM'
            : 'AM'
        : '';
    String? valueSelected = '$hour:$minutes $mode';

    Future.delayed(Duration.zero, () async {
      _controller.text = something == -1 ? '' : valueSelected;
      _controller2.text = widget.initialText.toString() == '-1'
          ? ''
          : widget.initialText.toString();
      if (widget.type == InputTypes.TimeInput) {
        widget.value!(_controller.text, widget.keya);
      } else {
        widget.value!(_controller2.text, widget.keya);
      }
    });

    TimeOfDay startDate = TimeOfDay.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          widget.question!,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        if (widget.type == InputTypes.TimeInput)
          TextFormField(
            key: ValueKey(widget.keya),
            onTap: () {
              Navigator.of(context).push(
                showPicker(
                  context: context,
                  blurredBackground: true,
                  themeData: ThemeData(),
                  value: Time(
                    hour: TimeOfDay.now().hour,
                    minute: TimeOfDay.now().minute,
                  ),
                  onChange: (pickedDate) {
                    num? something = pickedDate.hour;
                    String? hour = something > 12
                        ? (something - 12).toString()
                        : pickedDate.hour.toString();
                    String? minutes = pickedDate.minute.toString();
                    String? mode = something > 12 ? 'PM' : 'AM';
                    _controller.text =
                        '${hour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $mode';
                    widget.value!('$hour:$minutes $mode', widget.keya);
                  },
                ),
              );
            },
            controller: _controller,
            readOnly: true,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).disabledColor,
                  width: 2,
                ),
              ),
            ),
          ),
        if (widget.type == InputTypes.NumberInput)
          Form(
            key: formGlobalKey,
            child: TextFormField(
              key: ValueKey(widget.keya),
              controller: _controller2,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!value!.contains(RegExp('^[0-9]*\$'))) {
                  return "Not a valid number";
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (newValue) {
                if (formGlobalKey.currentState!.validate()) {
                  widget.value!(newValue, widget.keya);
                }
              },
            ),
          ),
      ],
    );
  }
}
