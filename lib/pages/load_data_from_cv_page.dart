import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import '../misc/linkedin_data_structs.dart';

Future<Directory?> getFilesFromZip(File myZipData) async {
  final appDataDir = Directory.systemTemp;
  final destinationDir = Directory("${appDataDir.path}/unzip");

  if (destinationDir.existsSync()) {
    destinationDir.deleteSync(recursive: true);
  }

  destinationDir.createSync();

  try {
    final bytes = myZipData.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    extractArchiveToDisk(archive, destinationDir.path);
  } on FileSystemException catch (e, stacktrace) {
    if (kDebugMode) {
      print('Exception: $e');
      print('Stacktrace: $stacktrace');
    }
    return null;
  }
  try {
    return Directory(destinationDir
        .listSync()
        .firstWhere(
          (element) => File("${element.path}/Profile.csv").existsSync(),
          orElse: () => File("${destinationDir.path}/Profile.csv").existsSync()
              ? destinationDir
              : throw StateError("No element"),
        )
        .path);
  } on StateError catch (e, stacktrace) {
    if (kDebugMode) {
      print('Exception: $e');
      print('Stacktrace: $stacktrace');
    }
    return null;
  }
}

Future<void> pickZipDataFile(
    BuildContext context, Function(CvData) setData) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['zip'],
  );
  if (result != null) {
    String? zipFilePath;
    if (kIsWeb) {
      if (result.files.isNotEmpty) {
        zipFilePath = result.files.first.name;
      } else {
        return;
      }
    } else {
      zipFilePath = result.files.single.path;
    }

    if (zipFilePath != null) {
      File file = File(zipFilePath);
      Directory? unpackedFiles = await getFilesFromZip(file);
      if (unpackedFiles != null) {
        var data = await CvData.create(unpackedFiles);
        setData(data);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: const Text("Warning!"),
              content: const Text("Invalid file format"),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK')),
              ]),
        );
      }
    }
  }
}
