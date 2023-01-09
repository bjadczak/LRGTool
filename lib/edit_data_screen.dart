import 'package:lrgtool/linkedin_data_structs.dart';
import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  EditData(CvData? data, {super.key}) : dataOnScreen = data ?? CvData.empty();

  CvData dataOnScreen;

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  @override
  initState() {
    super.initState();
    dataOnScreen = widget.dataOnScreen;
  }

  late CvData dataOnScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Data'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, dataOnScreen),
        ),
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          getTile('Edit profile data', () => launchEditScreen(context)),
          const Divider(),
          getTile('Edit past positions', () => {}),
          const Divider(),
          getTile('Edit education', () => {}),
          const Divider(),
          getTile('Edit skills', () => {}),
          const Divider(),
        ],
      )),
    );
  }

  Future<void> launchEditScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                EditProfileData(dataOnScreen.profileData)))) as ProfileData?;
    if (!mounted || result == null) return;

    setState(() {
      dataOnScreen.profileData = result;
    });
  }

  Widget getTile(String title, void Function()? onTap) {
    return ListTile(
      title: Center(child: Text(title)),
      onTap: onTap,
    );
  }
}

class EditProfileData extends StatefulWidget {
  const EditProfileData(ProfileData data, {super.key}) : _data = data;
  final ProfileData _data;
  @override
  State<EditProfileData> createState() => _EditProfileDataState();
}

class _EditProfileDataState extends State<EditProfileData> {
  @override
  initState() {
    super.initState();
    _data = widget._data;
  }

  late ProfileData _data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _data),
        ),
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          getTile(
              'First Name',
              _data.firstName,
              () => showDialog(
                    context: context,
                    builder: (context) => Dialog("First Name"),
                  ).then((valueFromDialog) {
                    if (valueFromDialog != null) {
                      setState(() {
                        _data.firstName = valueFromDialog;
                      });
                    }
                  })),
          const Divider(),
          getTile(
              'Second Name',
              _data.secondName,
              () => showDialog(
                    context: context,
                    builder: (context) => Dialog("Second Name"),
                  ).then((valueFromDialog) {
                    if (valueFromDialog != null) {
                      setState(() {
                        _data.secondName = valueFromDialog;
                      });
                    }
                  })),
          const Divider(),
          getTile(
              'Headline',
              _data.headline,
              () => showDialog(
                    context: context,
                    builder: (context) => Dialog("Headline"),
                  ).then((valueFromDialog) {
                    if (valueFromDialog != null) {
                      setState(() {
                        _data.headline = valueFromDialog;
                      });
                    }
                  })),
          const Divider(),
          getTile(
              'Industry',
              _data.industry,
              () => showDialog(
                    context: context,
                    builder: (context) => Dialog("Industry"),
                  ).then((valueFromDialog) {
                    if (valueFromDialog != null) {
                      setState(() {
                        _data.industry = valueFromDialog;
                      });
                    }
                  })),
          const Divider(),
          getTile(
              'Location',
              _data.location,
              () => showDialog(
                    context: context,
                    builder: (context) => Dialog("Location"),
                  ).then((valueFromDialog) {
                    if (valueFromDialog != null) {
                      setState(() {
                        _data.location = valueFromDialog;
                      });
                    }
                  })),
          const Divider(),
          getTile(
              'e-mail',
              _data.email,
              () => showDialog(
                    context: context,
                    builder: (context) => Dialog("e-mail"),
                  ).then((valueFromDialog) {
                    if (valueFromDialog != null) {
                      setState(() {
                        _data.email = valueFromDialog;
                      });
                    }
                  })),
          const Divider(),
        ],
      )),
    );
  }

  Widget getTile(String filed, String value, void Function()? onTap) {
    return ListTile(
      title: Row(
        children: [
          Flexible(
              flex: 1,
              child: Center(
                child: Text(filed),
              )),
          Flexible(
            flex: 2,
            child: Text(value, style: Theme.of(context).textTheme.headline5),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class Dialog extends StatefulWidget {
  @override
  State<Dialog> createState() => _DialogState();

  final String field;

  Dialog(this.field, {super.key});
}

class _DialogState extends State<Dialog> {
  String field = "";
  String content = "";

  @override
  void initState() {
    super.initState();
    field = widget.field;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        onChanged: (value) => setState(() {
          content = value;
        }),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context, content),
            child: const Text('Confirm')),
      ],
    );
  }
}
