import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';
part 'linkedin_data_structs.g.dart';

@JsonSerializable(constructor: "_", explicitToJson: true)
class PositionData {
  String companyName;
  String title;
  String description;
  String location;
  DateTime? startedOn;
  DateTime? finishedOn;

  PositionData._(this.companyName, this.title, this.description, this.location,
      this.startedOn, this.finishedOn);
  PositionData.empty()
      : companyName = "",
        title = "",
        description = "",
        location = "",
        startedOn = null,
        finishedOn = null;

  factory PositionData(String companyName, String title, String description,
      String location, String startedOn, String finishedOn) {
    DateTime? start;
    DateTime? finish;

    try {
      if (startedOn.length > 4) {
        start = DateFormat("MMM yyyy").parse(startedOn);
      } else {
        start = DateFormat("yyyy").parse(startedOn);
      }
    } on FormatException catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      start = null;
    }
    try {
      if (finishedOn.length > 4) {
        finish = DateFormat("MMM yyyy").parse(finishedOn);
      } else if (finishedOn.length > 0) {
        finish = DateFormat("yyyy").parse(finishedOn);
      }
    } on FormatException catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      finish = null;
    }
    return PositionData._(
        companyName, title, description, location, start, finish);
  }
  factory PositionData.fromJson(Map<String, dynamic> json) =>
      _$PositionDataFromJson(json);
  Map<String, dynamic> toJson() => _$PositionDataToJson(this);

  void debugPrint() {
    print(toJson());
  }
}

@JsonSerializable(explicitToJson: true)
class ProfileData {
  String firstName;
  String secondName;
  String headline;
  String industry;
  String location;
  String email;
  String summary;

  ProfileData(this.firstName, this.secondName, this.headline, this.industry,
      this.location, this.email, this.summary);
  ProfileData.empty()
      : firstName = "",
        secondName = "",
        headline = "",
        industry = "",
        location = "",
        email = "",
        summary = "";

  bool get isEmpty {
    return firstName.isEmpty &&
        secondName.isEmpty &&
        headline.isEmpty &&
        industry.isEmpty &&
        location.isEmpty &&
        email.isEmpty &&
        summary.isEmpty;
  }

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);

  void debugPrint() {
    print(toJson());
  }
}

@JsonSerializable(constructor: "_", explicitToJson: true)
class EducationData {
  String schoolName;
  DateTime? startedOn;
  DateTime? finishedOn;
  String degree;
  String course;

  EducationData._(this.schoolName, this.startedOn, this.finishedOn, this.degree,
      this.course);

  EducationData.empty()
      : schoolName = "",
        startedOn = null,
        finishedOn = null,
        degree = "",
        course = "";
  factory EducationData(
      String schoolName, String startedOn, String finishedOn, String degree) {
    DateTime? start;
    DateTime? finish;

    try {
      if (startedOn.length > 4) {
        start = DateFormat("MMM yyyy").parse(startedOn);
      } else {
        start = DateFormat("yyyy").parse(startedOn);
      }
    } on FormatException catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      start = null;
    }
    try {
      if (finishedOn.length > 4) {
        finish = DateFormat("MMM yyyy").parse(finishedOn);
      } else if (finishedOn.length > 0) {
        finish = DateFormat("yyyy").parse(finishedOn);
      }
    } on FormatException catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      finish = null;
    }

    return EducationData._(schoolName, start, finish, degree, "");
  }

  factory EducationData.fromJson(Map<String, dynamic> json) =>
      _$EducationDataFromJson(json);
  Map<String, dynamic> toJson() => _$EducationDataToJson(this);

  void debugPrint() {
    print(toJson());
  }
}

@JsonSerializable(explicitToJson: true)
class SkillData {
  String skill;

  SkillData(this.skill);
  SkillData.empty() : skill = "";

  factory SkillData.fromJson(Map<String, dynamic> json) =>
      _$SkillDataFromJson(json);
  Map<String, dynamic> toJson() => _$SkillDataToJson(this);

  void debugPrint() {
    print(toJson());
  }

  @override
  bool operator ==(Object other) {
    return other is SkillData && other.skill == skill;
  }

  @override
  int get hashCode => skill.hashCode;
}

@JsonSerializable(constructor: "_", explicitToJson: true)
class CvData {
  List<PositionData> positions;
  List<EducationData> education;
  List<SkillData> skills;
  ProfileData profileData;

  CvData._(this.positions, this.education, this.skills, this.profileData);

  CvData.empty()
      : positions = [],
        education = [],
        skills = [],
        profileData = ProfileData.empty();

  static Future<CvData> create(Directory unpackedCsvFiles) async {
    var positions = await _parsePositions(unpackedCsvFiles);
    var profileData = await _parseProfile(unpackedCsvFiles);
    var education = await _parseEducation(unpackedCsvFiles);
    var skills = await _parseSkills(unpackedCsvFiles);

    return CvData._(positions, education, skills, profileData);
  }

  factory CvData.fromJson(Map<String, dynamic> json) => _$CvDataFromJson(json);
  Map<String, dynamic> toJson() => _$CvDataToJson(this);

  void debugPrintJson() {
    print(toJson());
  }

  @override
  bool operator ==(Object other) {
    return other is CvData &&
        other.skills == skills &&
        other.education == education &&
        other.positions == positions &&
        other.profileData == profileData;
  }

  bool get isEmpty {
    return positions.isEmpty &&
        education.isEmpty &&
        skills.isEmpty &&
        profileData.isEmpty;
  }

  void debugPrint() {
    profileData.debugPrint();
    for (var pos in positions) {
      pos.debugPrint();
    }
    for (var edu in education) {
      edu.debugPrint();
    }
    for (var skill in skills) {
      skill.debugPrint();
    }
  }

  static Future<List<PositionData>> _parsePositions(
      Directory unpackedCsvFiles) async {
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
    } on Exception catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
    }

    return outData;
  }

  static Future<ProfileData> _parseProfile(Directory unpackedCsvFiles) async {
    File profileCsv = File("${unpackedCsvFiles.path}/Profile.csv");
    File emailCsv = File("${unpackedCsvFiles.path}/Email Addresses.csv");

    if (!(await profileCsv.exists()) && !(await emailCsv.exists())) {
      return ProfileData.empty();
    }
    ProfileData outData;
    try {
      List<List<dynamic>> rowsAsListOfValuesProfile =
          await _getListFromCSV(profileCsv);
      List<List<dynamic>> rowsAsListOfValuesEmail =
          await _getListFromCSV(emailCsv);

      // First line is an header
      var row = rowsAsListOfValuesProfile[1];
      String email;
      try {
        email = rowsAsListOfValuesEmail.firstWhere(
          (element) => element[1] == "Yes" && element[2] == "Yes",
          orElse: () => [""],
        )[0];
      } on Exception catch (e, stacktrace) {
        print('Exception: ' + e.toString());
        print('Stacktrace: ' + stacktrace.toString());
        email = "";
      }

      outData =
          ProfileData(row[0], row[1], row[5], row[7], row[9], email, row[6]);
    } on Exception catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
      outData = ProfileData.empty();
    }

    return outData;
  }

  static Future<List<EducationData>> _parseEducation(
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
    } on Exception catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
    }

    return outData;
  }

  static Future<List<SkillData>> _parseSkills(
      Directory unpackedCsvFiles) async {
    File skillsCSV = File("${unpackedCsvFiles.path}/Skills.csv");
    File endorsementCSV =
        File("${unpackedCsvFiles.path}/Endorsement_Received_Info.csv");

    if (!(await skillsCSV.exists()) && !(await endorsementCSV.exists())) {
      return [];
    }
    List<SkillData> outData = [];

    try {
      List<List<dynamic>> rowsAsListOfValuesSkills = [];
      List<List<dynamic>> rowsAsListOfValuesEndorsment = [];
      if ((await skillsCSV.exists())) {
        rowsAsListOfValuesSkills = await _getListFromCSV(skillsCSV);
        // First line is an header
        for (var row in rowsAsListOfValuesSkills.getRange(
            1, rowsAsListOfValuesSkills.length)) {
          outData.add(SkillData(row[0]));
        }
      }
      if ((await endorsementCSV.exists())) {
        rowsAsListOfValuesEndorsment = await _getListFromCSV(endorsementCSV);
        for (var row in rowsAsListOfValuesEndorsment.getRange(
            1, rowsAsListOfValuesEndorsment.length)) {
          SkillData skill = SkillData(row[1]);
          if (row[4] == "ACCEPTED" && !outData.contains(skill)) {
            outData.add(skill);
          }
        }
      }
    } on Exception catch (e, stacktrace) {
      print('Exception: ' + e.toString());
      print('Stacktrace: ' + stacktrace.toString());
    }

    return outData;
  }

  static Future<List<List>> _getListFromCSV(File csvFile) async {
    return const CsvToListConverter(eol: "\n", shouldParseNumbers: false)
        .convert(await csvFile.readAsString());
  }

  List<ListItem> getListOfData() {
    List<ListItem> items = [];

    // Add profile data
    items.add(HeadingItem("Profile data"));
    items.add(MessageItem(
        "${profileData.firstName} ${profileData.secondName}", "Name"));
    items.add(MessageItem(profileData.summary, "Summary"));
    items.add(MessageItem(profileData.email, "e-mail"));
    items.add(MessageItem(profileData.headline, "Profile headline"));
    items.add(MessageItem(profileData.industry, "Industry"));
    items.add(MessageItem(profileData.location, "Location"));

    // Add Positions
    items.add(HeadingItem("Past positions"));
    for (var position in positions) {
      items.add(SubHeadingItem(position.companyName, "Company"));
      items.add(MessageItem(position.title, "Title"));
      if (position.description.isNotEmpty) {
        items.add(MessageItem(position.description, "Description"));
      }
      if (position.location.isNotEmpty) {
        items.add(MessageItem(position.location, "Location"));
      }
      if (position.startedOn != null) {
        items.add(MessageItem(
            "${position.startedOn?.year}.${position.startedOn?.month}",
            "Started on"));
      }
      if (position.finishedOn != null) {
        items.add(MessageItem(
            "${position.finishedOn?.year}.${position.finishedOn?.month}",
            "Finished on"));
      }
    }

    // Add Education
    items.add(HeadingItem("Education"));
    for (var edu in education) {
      items.add(SubHeadingItem(edu.schoolName, "School name"));
      items.add(MessageItem(edu.degree, "Degree"));
      if (edu.startedOn != null) {
        items.add(MessageItem("${edu.startedOn?.year}", "Started on"));
      }
      if (edu.finishedOn != null) {
        items.add(MessageItem(
            "${edu.finishedOn?.year}",
            (edu.finishedOn?.year ?? (DateTime.now().year + 1)) >
                    DateTime.now().year
                ? "Will finish on"
                : "Finished on"));
      }
    }

    // Add Skills
    items.add(HeadingItem("Skills"));
    for (var skill in skills) {
      items.add(MessageItem(skill.skill, "Skill"));
    }

    return items;
  }
}

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline4,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

class SubHeadingItem implements ListItem {
  final String sender;
  final String body;

  SubHeadingItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      sender,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
