import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'linkedin_data_structs.dart';

class LoadDataFromZip extends StatefulWidget {
  LoadDataFromZip({super.key});

  @override
  State<LoadDataFromZip> createState() => _LoadDataFromZipState();
}

class _LoadDataFromZipState extends State<LoadDataFromZip> {
  final _appDataDir = Directory.systemTemp;

  List<ListItem> items = [];

  Future<void> _pickZipDataFile(context) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      String? zipFilePath = result.files.single.path;
      if (zipFilePath != null) {
        File file = File(zipFilePath);
        Directory? unpackedFiles = await _getFilesFromZip(file);
        if (unpackedFiles != null) {
          var data = await CvData.create(unpackedFiles);
          setState(() {
            items = data.getListOfData();
          });
        } else {
          final snackBar = SnackBar(
            content: const Text('Finvalid file format'),
            action: SnackBarAction(
              label: 'Clear data',
              onPressed: () {
                setState(() {
                  items = [];
                });
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  Future<Directory?> _getFilesFromZip(File myZipData) async {
    final destinationDir = Directory("${_appDataDir.path}/unzip");

    if (destinationDir.existsSync()) {
      destinationDir.deleteSync(recursive: true);
    }

    destinationDir.createSync();

    final extractFutures = <Future>[];

    try {
      extractFutures.add(ZipFile.extractToDirectory(
        zipFile: myZipData,
        destinationDir: destinationDir,
      ));

      await Future.wait<void>(extractFutures);
    } on PlatformException catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      return null;
    }
    try {
      for (var element in destinationDir.listSync()) {
        print(element.path);
      }
      return Directory(destinationDir
          .listSync()
          .firstWhere(
            (element) => File("${element.path}/Profile.csv").existsSync(),
            orElse: () =>
                File("${destinationDir.path}/Profile.csv").existsSync()
                    ? destinationDir
                    : throw StateError("No element"),
          )
          .path);
    } on StateError catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load data from zip file'),
      ),
      body: Center(
        child: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
      floatingActionButton: loadZipFileButton(context),
    );
  }

  FloatingActionButton loadZipFileButton(context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _pickZipDataFile(context);
      },
      icon: const Icon(Icons.file_open),
      label: const Text('Open Zip File'),
    );
  }
}
