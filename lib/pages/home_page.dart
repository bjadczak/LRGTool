import 'package:firebase_auth/firebase_auth.dart';
import 'package:lrgtool/misc/auth.dart';
import 'package:flutter/material.dart';
import 'package:lrgtool/pages/create_pdf_page.dart';
import 'package:lrgtool/misc/database_handler.dart';
import 'package:lrgtool/pages/look_through_my_cv_page.dart';

import 'load_data_from_cv_page.dart';
import 'edit_data_page.dart';
import 'package:lrgtool/misc/linkedin_data_structs.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  CvData? _cvData;
  List<ListItem> items = [];

  Widget _title() {
    return const Text('Home page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      drawer: NavigationDrawer(
          setNullData, setNewCvData, getCurrentCvData, setCvDataName),
      body: Center(
        child: contentOfHomePage(),
      ),
    );
  }

  Widget contentOfHomePage() {
    if (items.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.all(30.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      );
    } else {
      return Text(
        "No data to show",
        style: Theme.of(context).textTheme.headline5,
      );
    }
  }

  void setNewCvData(CvData? newData) {
    setState(() {
      if (newData?.isEmpty ?? true) {
        _cvData = null;
        items = [];
      } else {
        _cvData = newData;
        items = _cvData?.getListOfData(forHomePage: true) ?? [];
      }
    });
  }

  void setNullData() {
    setState(() {
      _cvData = null;
      items = [];
    });
  }

  CvData? getCurrentCvData() {
    return _cvData;
  }

  void setCvDataName(String newName) {
    setState(() {
      _cvData?.nameOfCv = newName;
    });
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer(
    this.setDataNull,
    this.setData,
    this.getCurrentData,
    this.setCvDataName, {
    Key? key,
  }) : super(key: key);

  final void Function() setDataNull;
  final void Function(CvData?) setData;
  final CvData? Function() getCurrentData;
  final void Function(String) setCvDataName;

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late void Function() setDataNull;
  late void Function(CvData?) setData;
  late CvData? Function() getCurrentData;
  late void Function(String) setCvDataName;
  @override
  void initState() {
    setDataNull = widget.setDataNull;
    setData = widget.setData;
    getCurrentData = widget.getCurrentData;
    setCvDataName = widget.setCvDataName;
    super.initState();
  }

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
                const Text(
                  "Logged on as",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Auth().currentUser?.email ?? "No user loged in",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [
                const Text(
                  "Offline mode",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
      ),
    );
  }

  Future<void> launchEditData(BuildContext context) async {
    Navigator.pop(context);
    var cvData = getCurrentData() ?? CvData.empty();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditData(cvData)),
    ) as CvData?;

    setData(result);
  }

  Future<void> launchLoadingFromZip(BuildContext context) async {
    Navigator.pop(context);
    var cvData = getCurrentData();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadDataFromZip(cvData)),
    ) as CvData?;

    setData(result);
  }

  Future<void> launchLoadingFromdatabase(BuildContext context) async {
    Navigator.pop(context);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LookThroughFetchedCVs()),
    ) as CvData?;

    if (result != null) setData(result);
  }

  Future<void> launchCreatePdfScreen(BuildContext context) async {
    Navigator.pop(context);
    var cvData = getCurrentData() ?? CvData.empty();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePDF(cvData)),
    ) as CvData?;
  }

  Future<void> signOut(BuildContext context) async {
    if (Auth().currentUser != null) {
      Navigator.pop(context);
      await Auth().signOut();
    } else {
      Navigator.pop(context);
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  ListTile loadFromZipOrClear(BuildContext context) {
    return getCurrentData() == null
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
              setDataNull();
              setState(() {});
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
            enabled: Auth().currentUser != null,
            leading: const Icon(Icons.upload),
            title: const Text("Upload current CV"),
            onTap: () =>
                {showUploadDilog(context, getCurrentData, setCvDataName)},
          ),
          ListTile(
            enabled: Auth().currentUser != null,
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

  Future<void> showUploadDilog(BuildContext context,
      CvData? Function() getCurrentData, void Function(String) setCvDataName) {
    return showDialog(
      context: context,
      builder: (context) {
        var content = getCurrentData()?.nameOfCv ?? "";
        return AlertDialog(
          title: const Text("Upload CV"),
          content: TextField(
            maxLines: 1,
            controller: TextEditingController(text: content),
            onChanged: (value) => content = value,
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  if (content.isNotEmpty) {
                    Navigator.pop(context, content);
                  } else {}
                },
                child: const Text('Confirm')),
          ],
        );
      },
    ).then(
      (valueFromDialog) async {
        if (valueFromDialog != null) {
          CvData potential = await DatabaseHandler()
              .findWithName(Auth().currentUser?.uid ?? "", valueFromDialog);
          if (!mounted) return;
          if (potential.isEmpty) {
            sendCvToDatabase(
                context, valueFromDialog, getCurrentData, setCvDataName);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Warning!"),
                  content: Text(
                      "You are trying to overwrite CV from ${potential.timeOfCreation}"),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes, overwrite')),
                  ],
                );
              },
            ).then((value) {
              if (value) {
                sendCvToDatabase(
                    context, valueFromDialog, getCurrentData, setCvDataName);
              }
            });
          }
        }
      },
    );
  }

  void sendCvToDatabase(BuildContext context, valueFromDialog,
      CvData? Function() getCurrentData, void Function(String) setCvDataName) {
    if (getCurrentData() == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text("Warning!"),
            content: const Text("Can't upload empty CV, first add data."),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK')),
            ]),
      );
    } else {
      setCvDataName(valueFromDialog);
      DatabaseHandler().createUser(
          Auth().currentUser?.uid ?? "", getCurrentData() ?? CvData.empty());
    }
  }
}
