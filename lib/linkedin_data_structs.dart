import 'package:intl/intl.dart';

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

  ProfileData(this.firstName, this.secondName, this.headLine, this.industry,
      this.location);
  ProfileData.empty()
      : firstName = "",
        secondName = "",
        headLine = "",
        industry = "",
        location = "";
  void debugPrint() {
    print(
        "Profile of ${firstName} ${secondName}. ${headLine} ${industry} ${location}");
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
