import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'linkedin_data_structs.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class LoadDataFromZip extends StatefulWidget {
  CvData? _cvData;

  LoadDataFromZip(CvData? cvData, {super.key}) : _cvData = cvData;

  @override
  State<LoadDataFromZip> createState() => _LoadDataFromZipState(_cvData);
}

class _LoadDataFromZipState extends State<LoadDataFromZip> {
  final _appDataDir = Directory.systemTemp;

  List<ListItem> items = [];
  bool _showClear = false;
  CvData? _cvData;

  _LoadDataFromZipState(cvData) : _cvData = cvData {
    items = _cvData?.getListOfData() ?? [];
    _showClear = cvData != null;
  }

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
            _cvData = data;
            items = data.getListOfData();
            _showClear = true;
          });
        } else {
          const snackBar = SnackBar(
            content: Text('Finvalid file format'),
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
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _cvData),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
      floatingActionButton: _getFAB(context),
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

  Widget _getFAB(context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Theme.of(context).primaryColor,
      animatedIconTheme: const IconThemeData(color: Colors.white),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          labelStyle: const TextStyle(color: Colors.white),
          labelBackgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.file_open),
          onTap: () {
            _pickZipDataFile(context);
          },
          label: 'Open Zip File',
        ),
        // FAB 2
        SpeedDialChild(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          labelStyle: const TextStyle(color: Colors.white),
          labelBackgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.clear),
          visible: _showClear,
          onTap: () {
            setState(() {
              items = [];
              _cvData = null;
              _showClear = false;
            });
          },
          label: 'Clear Data',
        )
      ],
    );
  }
}
