import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'linkedin_data_structs.dart';

class ThirdRoute extends StatelessWidget {
  ThirdRoute({super.key});

  final _appDataDir = Directory.systemTemp;

  void _pickFile() async {
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
          CvData data = await CvData.create(unpackedFiles);
          data.debugPrint();
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
