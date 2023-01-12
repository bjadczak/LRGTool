import 'package:firebase_auth/firebase_auth.dart';
import 'package:lrgtool/auth.dart';
import 'package:flutter/material.dart';
import 'package:lrgtool/create_pdf_screen.dart';
import 'package:lrgtool/database_handler.dart';
import 'package:lrgtool/look_through_my_cv.dart';

import '../load_data_screen.dart';
import '../edit_data_screen.dart';
import 'package:lrgtool/linkedin_data_structs.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  CvData? _cvData;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'You are not logged in');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () {
        if (user == null) {
          Navigator.pop(context);
        } else {
          signOut();
        }
      },
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
            loadFromZipOrClear(context),
            ElevatedButton(
              child: Text(_cvData?.isEmpty ?? true
                  ? "Insert data screen"
                  : 'Edit data screen'),
              onPressed: () {
                launchEditData(context);
              },
            ),
            ElevatedButton(
              child: Text("Show UID"),
              onPressed: () {
                print(Auth().currentUser?.uid ?? "No user loged in");
              },
            ),
            ElevatedButton(
              child: Text("Upload CV"),
              onPressed: () {
                DatabaseHandler().createUser(
                    Auth().currentUser?.uid ?? "", _cvData ?? CvData.empty());
              },
            ),
            ElevatedButton(
              child: Text("Load CV from datebase"),
              onPressed: () {
                launchLoadingFromdatabase(context);
              },
            ),
            ElevatedButton(
              child: Text("Create PDF"),
              onPressed: () {
                launchCreatePdfScreen(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchEditData(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditData(_cvData)),
    ) as CvData?;

    if (!mounted) return;

    setState(() {
      if (result?.isEmpty ?? true) {
        _cvData = null;
      } else {
        _cvData = result;
      }
    });
  }

  ElevatedButton loadFromZipOrClear(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Unavilable on web'),
    );

    return _cvData == null
        ? kIsWeb
            ? ElevatedButton(
                child: const Text('Load data from Zip'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              )
            : ElevatedButton(
                child: const Text('Load data from Zip'),
                onPressed: () {
                  launchLoadingFromZip(context);
                },
              )
        : ElevatedButton(
            child: const Text('Clear data'),
            onPressed: () {
              setState(() {
                _cvData = null;
              });
            },
          );
  }

  Future<void> launchLoadingFromZip(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadDataFromZip(_cvData)),
    ) as CvData?;

    if (!mounted) return;

    setState(() {
      _cvData = result;
    });
  }

  Future<void> launchLoadingFromdatabase(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LookThroughFetchedCVs()),
    ) as CvData?;

    if (!mounted) return;

    setState(() {
      _cvData = result;
    });
  }

  Future<void> launchCreatePdfScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreatePDF(_cvData ?? CvData.empty())),
    );
  }
}
