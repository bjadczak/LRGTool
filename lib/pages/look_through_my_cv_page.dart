import 'package:flutter/material.dart';
import 'package:lrgtool/misc/auth.dart';
import 'package:lrgtool/misc/database_handler.dart';
import 'package:lrgtool/misc/linkedin_data_structs.dart';

class LookThroughFetchedCVs extends StatefulWidget {
  const LookThroughFetchedCVs({super.key});

  @override
  State<LookThroughFetchedCVs> createState() => _LookThroughFetchedCVsState();
}

class _LookThroughFetchedCVsState extends State<LookThroughFetchedCVs> {
  List<CvData> items = [];

  @override
  initState() {
    super.initState();
    reloadData();
  }

  void removeItem(CvData remove) {
    DatabaseHandler().removeCv(Auth().currentUser?.uid ?? "", remove.nameOfCv);
  }

  Future<void> reloadData() async {
    await DatabaseHandler()
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
                title: Text('CV "${item.nameOfCv}"'),
                subtitle: Text("Created on ${item.formatedTimeOfCreation}"),
                onTap: () => setState(() {
                  Navigator.pop(context, item);
                }),
                trailing: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Warning!"),
                          content: Text(
                              'You are trying to delete CV "${item.nameOfCv}"'),
                          actions: [
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel')),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Yes, delete')),
                          ],
                        );
                      },
                    ).then((value) {
                      if (value) {
                        removeItem(item);
                        reloadData();
                      }
                    });
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
