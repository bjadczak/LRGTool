import 'package:lrgtool/linkedin_data_structs.dart';
import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  EditData(CvData? data, {super.key}) : dataOnScreen = data ?? CvData.empty();

  final CvData dataOnScreen;

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
          getTile(
              'Edit profile data', () => launchEditProfileDataScreen(context)),
          const Divider(),
          getTile(
              'Edit past positions', () => launchEditPositionsScreen(context)),
          const Divider(),
          getTile('Edit education', () => {}),
          const Divider(),
          getTile('Edit skills', () => {}),
          const Divider(),
        ],
      )),
    );
  }

  Future<void> launchEditProfileDataScreen(BuildContext context) async {
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

  Future<void> launchEditPositionsScreen(BuildContext context) async {
    final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => EditPositions(dataOnScreen.positions))))
        as List<PositionData>?;
    if (!mounted || result == null) return;

    setState(() {
      dataOnScreen.positions = result;
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
        children: widgetListForProfileData(context),
      )),
    );
  }

  List<Widget> widgetListForProfileData(BuildContext context) {
    return <Widget>[
      getTile(
          'First Name',
          _data.firstName,
          () => showDialog(
                context: context,
                builder: (context) => const Dialog("First Name"),
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
                builder: (context) => const Dialog("Second Name"),
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
                builder: (context) => const Dialog("Headline"),
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
                builder: (context) => const Dialog("Industry"),
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
                builder: (context) => const Dialog("Location"),
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
                builder: (context) => const Dialog("e-mail"),
              ).then((valueFromDialog) {
                if (valueFromDialog != null) {
                  setState(() {
                    _data.email = valueFromDialog;
                  });
                }
              })),
      const Divider(),
    ];
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

class EditPositions extends StatefulWidget {
  const EditPositions(List<PositionData> data, {super.key}) : _data = data;
  final List<PositionData> _data;
  @override
  State<EditPositions> createState() => _EditPositions();
}

class _EditPositions extends State<EditPositions> {
  @override
  initState() {
    super.initState();
    _data = widget._data;
  }

  late List<PositionData> _data;
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
          children: widgetListOfPositions(context),
        ),
      ),
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

  Future<DateTime?> _selectDate(BuildContext context, DateTime initial) async {
    return await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
  }

  List<Widget> widgetListOfPositions(BuildContext context) {
    List<Widget> listOfPositions = [];
    for (var posData in _data) {
      listOfPositions.add(
        getTile(
          'Company Name',
          posData.companyName,
          () => showDialog(
            context: context,
            builder: (context) => const Dialog("Company Name"),
          ).then(
            (valueFromDialog) {
              if (valueFromDialog != null) {
                setState(
                  () {
                    posData.companyName = valueFromDialog;
                  },
                );
              }
            },
          ),
        ),
      );
      listOfPositions.add(const Divider());
      listOfPositions.add(
        getTile(
          'Title',
          posData.title,
          () => showDialog(
            context: context,
            builder: (context) => const Dialog("Title"),
          ).then(
            (valueFromDialog) {
              if (valueFromDialog != null) {
                setState(
                  () {
                    posData.title = valueFromDialog;
                  },
                );
              }
            },
          ),
        ),
      );
      listOfPositions.add(const Divider());
      listOfPositions.add(
        getTile(
          'Description',
          posData.description,
          () => showDialog(
            context: context,
            builder: (context) => const Dialog("Description"),
          ).then(
            (valueFromDialog) {
              if (valueFromDialog != null) {
                setState(
                  () {
                    posData.description = valueFromDialog;
                  },
                );
              }
            },
          ),
        ),
      );
      listOfPositions.add(const Divider());
      listOfPositions.add(
        getTile(
          'Location',
          posData.location,
          () => showDialog(
            context: context,
            builder: (context) => const Dialog("Location"),
          ).then(
            (valueFromDialog) {
              if (valueFromDialog != null) {
                setState(
                  () {
                    posData.location = valueFromDialog;
                  },
                );
              }
            },
          ),
        ),
      );
      listOfPositions.add(const Divider());
      listOfPositions.add(
        getTile(
            'Starting Date',
            posData.startedOn == null
                ? ""
                : "${posData.startedOn?.year}.${posData.startedOn?.month}",
            () => {
                  _selectDate(context, posData.startedOn ?? DateTime.now())
                      .then(
                    (valueFromDialog) {
                      setState(
                        () {
                          setState(
                            () {
                              posData.startedOn = valueFromDialog;
                            },
                          );
                        },
                      );
                    },
                  )
                }),
      );
      listOfPositions.add(const Divider());
      listOfPositions.add(
        getTile(
            'Finished Date',
            posData.finishedOn == null
                ? ""
                : "${posData.finishedOn?.year}.${posData.finishedOn?.month}",
            () => {
                  _selectDate(context, posData.finishedOn ?? DateTime.now())
                      .then(
                    (valueFromDialog) {
                      setState(
                        () {
                          setState(
                            () {
                              posData.finishedOn = valueFromDialog;
                            },
                          );
                        },
                      );
                    },
                  )
                }),
      );
      listOfPositions.add(const Divider());
    }

    return listOfPositions;
  }
}

class Dialog extends StatefulWidget {
  @override
  State<Dialog> createState() => _DialogState();

  final String field;

  const Dialog(this.field, {super.key});
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
      title: Text(field),
      content: TextField(
        maxLines: null,
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

class DataDialog extends StatefulWidget {
  @override
  State<DataDialog> createState() => _DataDialogState();

  final String field;

  const DataDialog(this.field, {super.key});
}

class _DataDialogState extends State<DataDialog> {
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
      title: Text(field),
      content: TextField(
        maxLines: null,
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
