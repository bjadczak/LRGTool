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
      drawer: NavigationDrawer(),
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

  void setNewCvData(CvData? newData) {
    setState(() {
      if (newData?.isEmpty ?? true) {
        _cvData = null;
      } else {
        _cvData = newData;
      }
    });
  }

  void setNullData() {
    _cvData = null;
  }

  Future<void> launchEditData(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditData(_cvData)),
    ) as CvData?;

    if (!mounted) return;

    setNewCvData(result);
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

    setNewCvData(result);
  }

  Future<void> launchLoadingFromdatabase(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LookThroughFetchedCVs()),
    ) as CvData?;

    if (!mounted) return;

    setNewCvData(result);
  }

  Future<void> launchCreatePdfScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreatePDF(_cvData ?? CvData.empty())),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({
    Key? key,
  }) : super(key: key);

  static _HomePageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 18,
      ),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: Auth().currentUser != null
            ? [
                const Text("Logged on as"),
                Text(Auth().currentUser?.email ?? "No user loged in"),
              ]
            : [
                const Text("Offline mode"),
              ],
      ),
    );
  }

  Future<void> launchEditData(BuildContext context) async {
    var state = of(context);
    var cvData = state?._cvData ?? CvData.empty();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditData(cvData)),
    ) as CvData?;

    state?.setNewCvData(result);
  }

  Future<void> launchLoadingFromZip(BuildContext context) async {
    var state = of(context);
    var cvData = state?._cvData;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadDataFromZip(cvData)),
    ) as CvData?;

    state?.setNewCvData(result);
  }

  Future<void> launchLoadingFromdatabase(BuildContext context) async {
    var state = of(context);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LookThroughFetchedCVs()),
    ) as CvData?;

    state?.setNewCvData(result);
  }

  Future<void> launchCreatePdfScreen(BuildContext context) async {
    var state = of(context);
    var cvData = state?._cvData ?? CvData.empty();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePDF(cvData)),
    ) as CvData?;
  }

  Future<void> signOut(BuildContext context) async {
    Auth().currentUser != null
        ? await Auth().signOut()
        : Navigator.pop(context);
  }

  ListTile loadFromZipOrClear(BuildContext context) {
    var state = of(context);
    return state?._cvData == null
        ? ListTile(
            enabled: !kIsWeb,
            leading: const Icon(Icons.folder_zip),
            title: const Text("Load data from Zip"),
            onTap: () {
              launchLoadingFromZip(context);
            },
          )
        : ListTile(
            leading: const Icon(Icons.clear),
            title: const Text("Clear data"),
            onTap: () {
              state?.setNullData();
            },
          );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          loadFromZipOrClear(context),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Data"),
            onTap: () => {launchEditData(context)},
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text("generate PDF"),
            onTap: () => {launchCreatePdfScreen(context)},
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text("Upload current CV"),
            onTap: () => {
              DatabaseHandler().createUser(Auth().currentUser?.uid ?? "",
                  of(context)?._cvData ?? CvData.empty())
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Download CVs from database"),
            onTap: () => {launchLoadingFromdatabase(context)},
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sign out"),
            onTap: () => {signOut(context)},
          ),
        ],
      ),
    );
  }
}
