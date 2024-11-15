import 'package:flutter/material.dart';
import 'package:night_gschallenge/providers/worry_list_provider.dart';
import 'package:night_gschallenge/widgets/UI/loadingStateCreator.dart';
import 'package:provider/provider.dart';

class Worrycard extends StatelessWidget {
  final String? worry;
  final String? situation;
  final String? id;
  const Worrycard({super.key, this.worry, this.situation, this.id});

  @override
  Widget build(BuildContext context) {
    final worryProvider =
        Provider.of<WorryListProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Container(
          child: Icon(
            Icons.list_alt_rounded,
            color: Theme.of(context).iconTheme.color,
            size: 50,
          ),
        ),
        trailing: Container(
          child: IconButton(
            icon: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 50,
            ),
            onPressed: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return Center(
                    child: LoadingStateCreator(),
                  );
                },
              );
              worryProvider.deleteWorry(id!).then(
                (value) {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        horizontalTitleGap: 10,
        tileColor: Theme.of(context).primaryColor,
        // contentPadding: EdgeInsets.all(10),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            worry!,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        subtitle: Text(
          situation!,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
