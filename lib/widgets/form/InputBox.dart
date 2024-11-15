import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:night_gschallenge/screens/forms/onboardingform/main-form.dart';
import 'package:night_gschallenge/widgets/UI/elevated_buttons_with_icon.dart';
import 'package:night_gschallenge/widgets/UI/time_boxes.dart';

class InputBox extends StatefulWidget {
  final String? question;
  Function(String, int)? onPressedNext;
  void Function()? onPressedBack;
  InputTypes? inputType;
  int? currentQuestion;
  final String? labels;
  int max;
  int min;

  InputBox(
      {Key? key,
      this.question,
      this.onPressedNext,
      this.onPressedBack,
      this.inputType,
      this.currentQuestion,
      this.labels,
      this.max = -1,
      this.min = -1})
      : super(key: key);

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  TimeOfDay startDate = TimeOfDay.now();
  String? valueSelected = '';
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.question!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                if (widget.inputType == InputTypes.NumberInput)
                  Form(
                    key: formGlobalKey,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: widget.labels),
                      keyboardType: TextInputType.number,
                      autocorrect: true,
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if(!value!.contains(RegExp('^[0-9]*\$'))){
                          return "Not a valid number";
                        }
                        if (widget.min != -1 && widget.max != -1) {
                          if (int.parse(value) > widget.max) {
                            return "Enter value less than ${widget.max}";
                          } else if (int.parse(value) < widget.min) {
                            return "Enter value more than ${widget.min}";
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if(formGlobalKey.currentState!.validate()){
                          valueSelected = value;
                        }
                      },
                    ),
                  ),
                if (widget.inputType == InputTypes.HourMinuteInput)
                  TimePickerSpinner(
                    is24HourMode: false,
                    isShowSeconds: false,
                    normalTextStyle: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).disabledColor,
                    ),
                    highlightedTextStyle: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    spacing: 45,
                    itemHeight: 80,
                    isForce2Digits: true,
                    onTimeChange: (value) {
                      valueSelected = "${value.hour}:${value.minute}";
                    },
                  ),
                if (widget.inputType == InputTypes.TimeInput)
                  TimeBoxes(
                    hours: startDate.hour > 12
                        ? (startDate.hour - 12).toString()
                        : (startDate.hour).toString(),
                    minutes: startDate.minute.toString(),
                    meridian: startDate.hour > 12 ? 'PM' : 'AM',
                    onTap: () {
                      Navigator.of(context).push(showPicker(
                        context: context,
                        accentColor: Theme.of(context).canvasColor,
                        value: Time(
                          hour: startDate.hour,
                          minute: startDate.minute,
                        ),
                        onChange: (pickedDate) {
                          valueSelected =
                              "${pickedDate.hour}:${pickedDate.minute}";
                          setState(() {
                            startDate = pickedDate;
                          });
                        },
                      ));
                    },
                  ),
                if (widget.inputType == InputTypes.DateInput)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: widget.labels),
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime(2000, 1, 1),
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime.now().subtract(
                                const Duration(days: 18 * 365),
                              ),
                            ).then((value) {
                              setState(() {
                                _controller.text =
                                    DateFormat.yMMMMd('en_US').format(value!);
                              });
                            });
                          },
                          autocorrect: true,
                          controller: _controller,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            valueSelected = value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime(2000, 1, 1),
                            firstDate: DateTime(1900, 1, 1),
                            lastDate: DateTime.now().subtract(
                              const Duration(days: 18 * 365),
                            ),
                          ).then((value) {
                            setState(() {
                              _controller.text =
                                  DateFormat.yMMMMd('en_US').format(value!);
                            });
                          });
                        },
                      )
                    ],
                  ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButtonsWithIcon(
                      icon: Icons.navigate_before_rounded,
                      onPressed: widget.currentQuestion! <= 0
                          ? null
                          : widget.onPressedBack,
                      title: "Back",
                    ),
                    ElevatedButtonsWithIcon(
                      icon: Icons.navigate_next_rounded,
                      onPressed: () {
                        widget.onPressedNext!(
                            valueSelected.toString(), widget.currentQuestion!);
                      },
                      title: "Next",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}