import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/worry_list_provider.dart';
import 'package:provider/provider.dart';

class ResolutionCardWithComment extends StatefulWidget {
  bool isWriting = false;
  String worry, situation;
  String id;
  final notes;
  ResolutionCardWithComment(this.id, this.worry, this.situation, this.notes, {super.key});
  @override
  State<ResolutionCardWithComment> createState() =>
      _ResolutionCardWithCommentState();
}

class _ResolutionCardWithCommentState extends State<ResolutionCardWithComment> {
  @override
  Widget build(BuildContext context) {
    final worryProvider = Provider.of<WorryListProvider>(context);
    var controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).iconTheme.color,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.isWriting = !widget.isWriting;
                    });
                  },
                ),
              ],
            ),
          ),
          Text(
            widget.worry,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.situation,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notes',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          ),
          if (widget.notes.length > 0)
            ...widget.notes.map(
              (note) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.sticky_note_2_outlined,
                        color: Theme.of(context).iconTheme.color,
                        size: 40,
                      ),
                      title: Text(note),
                    ),
                  ),
                );
              },
            ),
          if (widget.notes.length == 0)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.sticky_note_2_outlined,
                    color: Theme.of(context).iconTheme.color,
                    size: 40,
                  ),
                  title: const Text("No notes available"),
                ),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          widget.isWriting
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autocorrect: true,
                    enableSuggestions: true,
                    controller: controller,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    cursorHeight: 20,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: 'Enter your notes here...',
                      alignLabelWithHint: false,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onSubmitted: (value) {
                      var list = widget.notes as List;
                      list.add(value);
                      worryProvider
                          .updateWorryList(widget.id, list)
                          .then((value) {
                        controller.clear();
                        setState(() {
                          widget.isWriting = false;
                        });
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
