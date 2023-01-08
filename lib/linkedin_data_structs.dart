import 'package:intl/intl.dart';

class PositionsData {
  final String companyName;
  final String title;
  final String description;
  final String location;
  final DateTime? startedOn;
  final DateTime? finishedOn;

  PositionsData._(this.companyName, this.title, this.description, this.location,
      this.startedOn, this.finishedOn);

  factory PositionsData(String companyName, String title, String description,
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
    return PositionsData._(
        companyName, title, description, location, start, finish);
  }

  void debugPrint() {
    print(
        "Job as ${this.title}, at ${this.companyName} located in ${this.location}.\n${this.description}. From ${this.startedOn} until ${this.finishedOn}.");
  }
}
