import 'package:lrgtool/linkedin_data_structs.dart';
import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  EditData(CvData? data, {super.key}) : dataOnScreen = data ?? CvData.empty();

  CvData dataOnScreen;

  @override
  State<EditData> createState() => _EditDataState(dataOnScreen);
}

class _EditDataState extends State<EditData> {
  _EditDataState(CvData data) : dataOnScreen = data;

  CvData dataOnScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Data'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }
}
