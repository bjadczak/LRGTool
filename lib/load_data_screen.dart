import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'package:csv/csv.dart';

import 'linkedin_data_structs.dart';

class ThirdRoute extends StatelessWidget {
  ThirdRoute({super.key});

  final _appDataDir = Directory.systemTemp;

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      String? zipFilePath = result.files.single.path;
      if (zipFilePath != null) {
        File file = File(zipFilePath);
        var tmp = await _getFilesFromZip(file);
        if (tmp != null) {
          final String endor =
              File("${tmp.path}/Positions.csv").readAsStringSync();
          print(endor);
          List<List<dynamic>> rowsAsListOfValues =
              const CsvToListConverter(eol: "\n").convert(endor);
          for (var row in rowsAsListOfValues) {
            final PositionsData data =
                PositionsData(row[0], row[1], row[2], row[3], row[4], row[5]);
            data.debugPrint();
          }
        }
      }
    }
  }

  Future<Directory?> _getFilesFromZip(File myZipData) async {
    final destinationDir = Directory("${_appDataDir.path}/unzip");

    myZipData.copy("${_appDataDir.path}/data.zip");
    final File zipFile = File("${_appDataDir.path}/data.zip");

    if (destinationDir.existsSync()) {
      destinationDir.deleteSync(recursive: true);
    }

    destinationDir.createSync();
    // test concurrent extraction
    final extractFutures = <Future>[];

    try {
      extractFutures.add(ZipFile.extractToDirectory(
        zipFile: zipFile,
        destinationDir: destinationDir,
      ));

      await Future.wait<void>(extractFutures);
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
    return Directory(destinationDir
        .listSync()
        .firstWhere(
            (element) => File("${element.path}/PhoneNumbers.csv").existsSync())
        .path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickFile();
              },
              child: const Text('Open File'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
