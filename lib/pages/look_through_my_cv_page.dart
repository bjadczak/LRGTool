import 'package:flutter/material.dart';
import 'package:lrgtool/misc/auth.dart';
import 'package:lrgtool/misc/database_handler.dart';
import 'package:lrgtool/misc/linkedin_data_structs.dart';

class LookThroughFetchedCVs extends StatefulWidget {
  @override
  State<LookThroughFetchedCVs> createState() => _LookThroughFetchedCVsState();
}

class _LookThroughFetchedCVsState extends State<LookThroughFetchedCVs> {
  List<CvData> items = [];

  @override
  initState() {
    super.initState();
    DatabaseHandler()
        .readCV(Auth().currentUser?.uid ?? "")
        .then((value) => setState(() => items = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My CVs"),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            DatabaseHandler()
                .readCV(Auth().currentUser?.uid ?? "")
                .then((value) => setState(() => items = value));
          },
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text("CV ${item.nameOfCv}"),
                subtitle: Text("Created on ${item.formatedTimeOfCreation}"),
                onTap: () => setState(() {
                  Navigator.pop(context, item);
                }),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    DatabaseHandler().removeCv(Auth().currentUser?.uid ?? "",
                        item.timeOfCreation.toString());
                    DatabaseHandler()
                        .readCV(Auth().currentUser?.uid ?? "")
                        .then((value) => setState(() => items = value));
                  },
                  icon:
                      const Icon(Icons.delete), //icon data for elevated button
                  label: const Text("Delete this CV"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}