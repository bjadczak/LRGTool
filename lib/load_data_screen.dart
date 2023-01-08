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
          await _parseLinkedInData(unpackedFiles);
        }
      }
    }
  }

  Future<void> _parseLinkedInData(Directory unpackedCsvFiles) async {
    var postions = await _parsePositions(unpackedCsvFiles);
    var profile = await _parseProfile(unpackedCsvFiles);
    var educations = await _parseEducation(unpackedCsvFiles);
    var skills = await _parseSkills(unpackedCsvFiles);

    profile.debugPrint();
    for (var position in postions) {
      position.debugPrint();
    }
    for (var education in educations) {
      education.debugPrint();
    }
    for (var skill in skills) {
      skill.debugPrint();
    }
  }

  Future<List<PositionData>> _parsePositions(Directory unpackedCsvFiles) async {
    File positionsCsv = File("${unpackedCsvFiles.path}/Positions.csv");

    if (!(await positionsCsv.exists())) {
      return [];
    }
    List<PositionData> outData = [];

    try {
      List<List<dynamic>> rowsAsListOfValues =
          await _getListFromCSV(positionsCsv);

      // First line is an header
      for (var row
          in rowsAsListOfValues.getRange(1, rowsAsListOfValues.length)) {
        outData
            .add(PositionData(row[0], row[1], row[2], row[3], row[4], row[5]));
      }
    } on Exception catch (_) {}

    return outData;
  }

  Future<ProfileData> _parseProfile(Directory unpackedCsvFiles) async {
    File profileCsv = File("${unpackedCsvFiles.path}/Profile.csv");

    if (!(await profileCsv.exists())) {
      return ProfileData.empty();
    }
    ProfileData outData;
    try {
      List<List<dynamic>> rowsAsListOfValues =
          await _getListFromCSV(profileCsv);

      // First line is an header
      var row = rowsAsListOfValues[1];

      outData = ProfileData(row[0], row[1], row[5], row[7], row[9]);
    } on Exception catch (_) {
      outData = ProfileData.empty();
    }

    return outData;
  }

  Future<List<EducationData>> _parseEducation(
      Directory unpackedCsvFiles) async {
    File educationCSV = File("${unpackedCsvFiles.path}/Education.csv");

    if (!(await educationCSV.exists())) {
      return [];
    }
    List<EducationData> outData = [];

    try {
      List<List<dynamic>> rowsAsListOfValues =
          await _getListFromCSV(educationCSV);

      // First line is an header
      for (var row
          in rowsAsListOfValues.getRange(1, rowsAsListOfValues.length)) {
        outData.add(EducationData(row[0], row[1], row[2], row[4]));
      }
    } on Exception catch (_) {}

    return outData;
  }

  Future<List<SkillData>> _parseSkills(Directory unpackedCsvFiles) async {
    File skillsCSV = File("${unpackedCsvFiles.path}/Skills.csv");
    File endorsementCSV =
        File("${unpackedCsvFiles.path}/Endorsement_Received_Info.csv");

    if (!(await skillsCSV.exists()) && !(await endorsementCSV.exists())) {
      return [];
    }
    List<SkillData> outData = [];

    try {
      List<List<dynamic>> rowsAsListOfValuesSkills =
          await _getListFromCSV(skillsCSV);
      List<List<dynamic>> rowsAsListOfValuesEndorsment =
          await _getListFromCSV(endorsementCSV);

      // First line is an header
      for (var row in rowsAsListOfValuesSkills.getRange(
          1, rowsAsListOfValuesSkills.length)) {
        outData.add(SkillData(row[0]));
      }
      for (var row in rowsAsListOfValuesEndorsment.getRange(
          1, rowsAsListOfValuesEndorsment.length)) {
        SkillData skill = SkillData(row[1]);
        if (row[4] == "ACCEPTED" && !outData.contains(skill)) {
          outData.add(skill);
        }
      }
    } on Exception catch (_) {}

    return outData;
  }

  Future<List<List>> _getListFromCSV(File csvFile) async {
    return const CsvToListConverter(eol: "\n", shouldParseNumbers: false)
        .convert(await csvFile.readAsString());
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
