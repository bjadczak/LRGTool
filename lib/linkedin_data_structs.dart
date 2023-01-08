import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class PositionData {
  final String companyName;
  final String title;
  final String description;
  final String location;
  final DateTime? startedOn;
  final DateTime? finishedOn;

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
      start = DateFormat("MMM yyyy").parse(startedOn);
    } on FormatException catch (_) {
      start = null;
    }
    try {
      finish = DateFormat("MMM yyyy").parse(finishedOn);
    } on FormatException catch (_) {
      finish = null;
    }
    return PositionData._(
        companyName, title, description, location, start, finish);
  }

  void debugPrint() {
    print(
        "Job as ${this.title}, at ${this.companyName} located in ${this.location}.\n${this.description}. From ${this.startedOn} until ${this.finishedOn}.");
  }
}

class ProfileData {
  final String firstName;
  final String secondName;
  final String headLine;
  final String industry;
  final String location;
  final String email;

  ProfileData(this.firstName, this.secondName, this.headLine, this.industry,
      this.location, this.email);
  ProfileData.empty()
      : firstName = "",
        secondName = "",
        headLine = "",
        industry = "",
        location = "",
        email = "";
  void debugPrint() {
    print(
        "Profile of ${firstName} ${secondName}. ${headLine} ${industry} ${location}. Email: ${email}");
  }
}

class EducationData {
  final String schoolName;
  final DateTime? startedOn;
  final DateTime? finishedOn;
  final String degree;

  EducationData._(
      this.schoolName, this.startedOn, this.finishedOn, this.degree);

  EducationData.empty()
      : schoolName = "",
        startedOn = null,
        finishedOn = null,
        degree = "";
  factory EducationData(
      String schoolName, String startedOn, String finishedOn, String degree) {
    DateTime? start;
    DateTime? finish;

    try {
      start = DateFormat("yyyy").parse(startedOn);
    } on FormatException catch (_) {
      start = null;
    }
    try {
      finish = DateFormat("yyyy").parse(finishedOn);
    } on FormatException catch (_) {
      finish = null;
    }

    return EducationData._(schoolName, start, finish, degree);
  }

  void debugPrint() {
    print(
        "${schoolName} started ${startedOn?.year}, finished ${finishedOn?.year} with ${degree}");
  }
}

class SkillData {
  final String skill;

  SkillData(this.skill);
  SkillData.empty() : skill = "";

  void debugPrint() {
    print("Skill: ${skill}");
  }

  @override
  bool operator ==(Object other) {
    return other is SkillData && other.skill == skill;
  }

  @override
  int get hashCode => skill.hashCode;
}

class CvData {
  late final List<PositionData> positions;
  late final List<EducationData> education;
  late final List<SkillData> skills;
  late final ProfileData profileData;

  CvData._(this.positions, this.education, this.skills, this.profileData);

  static Future<CvData> create(Directory unpackedCsvFiles) async {
    var positions = await _parsePositions(unpackedCsvFiles);
    var profileData = await _parseProfile(unpackedCsvFiles);
    var education = await _parseEducation(unpackedCsvFiles);
    var skills = await _parseSkills(unpackedCsvFiles);

    return CvData._(positions, education, skills, profileData);
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
    } on Exception catch (_) {}

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
      } on Exception catch (_) {
        email = "";
      }

      outData = ProfileData(row[0], row[1], row[5], row[7], row[9], email);
    } on Exception catch (_) {
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
    } on Exception catch (_) {}

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

  static Future<List<List>> _getListFromCSV(File csvFile) async {
    return const CsvToListConverter(eol: "\n", shouldParseNumbers: false)
        .convert(await csvFile.readAsString());
  }
}
