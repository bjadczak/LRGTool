import 'package:flutter/material.dart';
import 'package:lrgtool/misc/linkedin_data_structs.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent(this.data, {super.key});
  final CvData? data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text("Main page"),
        ],
      ),
    );
  }
}
