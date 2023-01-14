import 'package:lrgtool/misc/linkedin_data_structs.dart';
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
          getTile('Edit education', () => launchEditEducationsScreen(context)),
          const Divider(),
          getTile('Edit skills', () => launchEditSkillsScreen(context)),
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

  Future<void> launchEditEducationsScreen(BuildContext context) async {
    final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => EditEducations(dataOnScreen.education))))
        as List<EducationData>?;
    if (!mounted || result == null) return;

    setState(() {
      dataOnScreen.education = result;
    });
  }

  Future<void> launchEditSkillsScreen(BuildContext context) async {
    final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => EditSkills(dataOnScreen.skills))))
        as List<SkillData>?;
    if (!mounted || result == null) return;

    setState(() {
      dataOnScreen.skills = result;
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
                builder: (context) => Dialog("First Name", _data.firstName),
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
                builder: (context) => Dialog("Second Name", _data.secondName),
              ).then((valueFromDialog) {
                if (valueFromDialog != null) {
                  setState(() {
                    _data.secondName = valueFromDialog;
                  });
                }
              })),
      const Divider(),
      getTile(
          'Summary',
          _data.summary,
          () => showDialog(
                context: context,
                builder: (context) => Dialog("Summary", _data.summary),
              ).then((valueFromDialog) {
                if (valueFromDialog != null) {
                  setState(() {
                    _data.summary = valueFromDialog;
                  });
                }
              })),
      const Divider(),
      getTile(
          'Headline',
          _data.headline,
          () => showDialog(
                context: context,
                builder: (context) => Dialog("Headline", _data.headline),
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
                builder: (context) => Dialog("Industry", _data.industry),
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
                builder: (context) => Dialog("Location", _data.location),
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
                builder: (context) => Dialog("e-mail", _data.email),
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
        title: const Text('Edit Previous Positions'),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () => setState(() {
          _data.add(PositionData.empty());
        }),
      ),
    );
  }

  List<Widget> widgetListOfPositions(BuildContext context) {
    List<Widget> listOfPositions = [];
    for (var posData in _data) {
      listOfPositions.add(ListTile(
        title: Row(
          children: [
            Flexible(
                flex: 3,
                child: Center(
                  child: Text("Position number ${_data.indexOf(posData) + 1}"),
                )),
            Flexible(
              flex: 2,
              child: ElevatedButton(
                child: const Text("Remove position"),
                onPressed: () => {
                  setState(() {
                    _data.remove(posData);
                  })
                },
              ),
            ),
          ],
        ),
      ));
      listOfPositions.add(const Divider());
      listOfPositions.add(
        getTile(
          context,
          'Company Name',
          posData.companyName,
          () => showDialog(
            context: context,
            builder: (context) => Dialog("Company Name", posData.companyName),
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
          context,
          'Title',
          posData.title,
          () => showDialog(
            context: context,
            builder: (context) => Dialog("Title", posData.title),
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
          context,
          'Description',
          posData.description,
          () => showDialog(
            context: context,
            builder: (context) => Dialog("Description", posData.description),
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
          context,
          'Location',
          posData.location,
          () => showDialog(
            context: context,
            builder: (context) => Dialog("Location", posData.location),
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
            context,
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
            context,
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
      listOfPositions.add(const Divider(
        thickness: 2,
      ));
    }

    return listOfPositions;
  }
}

class EditEducations extends StatefulWidget {
  const EditEducations(List<EducationData> data, {super.key}) : _data = data;
  final List<EducationData> _data;
  @override
  State<EditEducations> createState() => _EditEducations();
}

class _EditEducations extends State<EditEducations> {
  @override
  initState() {
    super.initState();
    _data = widget._data;
  }

  late List<EducationData> _data;
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
          children: widgetListOfEducations(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () => setState(() {
          _data.add(EducationData.empty());
        }),
      ),
    );
  }

  List<Widget> widgetListOfEducations(BuildContext context) {
    List<Widget> listOfEducations = [];
    for (var eduData in _data) {
      listOfEducations.add(ListTile(
        title: Row(
          children: [
            Flexible(
                flex: 3,
                child: Center(
                  child: Text("School number ${_data.indexOf(eduData) + 1}"),
                )),
            Flexible(
              flex: 2,
              child: ElevatedButton(
                child: const Text("Remove position"),
                onPressed: () => {
                  setState(() {
                    _data.remove(eduData);
                  })
                },
              ),
            ),
          ],
        ),
      ));
      listOfEducations.add(const Divider());
      listOfEducations.add(
        getTile(
          context,
          'School Name',
          eduData.schoolName,
          () => showDialog(
            context: context,
            builder: (context) => Dialog("School Name", eduData.schoolName),
          ).then(
            (valueFromDialog) {
              if (valueFromDialog != null) {
                setState(
                  () {
                    eduData.schoolName = valueFromDialog;
                  },
                );
              }
            },
          ),
        ),
      );
      listOfEducations.add(const Divider());
      listOfEducations.add(
        getTile(
          context,
          'Degree',
          eduData.degree,
          () => showDialog(
            context: context,
            builder: (context) => Dialog("Degree", eduData.degree),
          ).then(
            (valueFromDialog) {
              if (valueFromDialog != null) {
                setState(
                  () {
                    eduData.degree = valueFromDialog;
                  },
                );
              }
            },
          ),
        ),
      );
      listOfEducations.add(const Divider());
      listOfEducations.add(
        getTile(
          context,
          'Course',
          eduData.course,
          () => showDialog(
            context: context,
            builder: (context) => Dialog("Course", eduData.course),
          ).then(
            (valueFromDialog) {
              if (valueFromDialog != null) {
                setState(
                  () {
                    eduData.course = valueFromDialog;
                  },
                );
              }
            },
          ),
        ),
      );
      listOfEducations.add(const Divider());
      listOfEducations.add(
        getTile(
            context,
            'Starting Date',
            eduData.startedOn == null
                ? ""
                : "${eduData.startedOn?.year}.${eduData.startedOn?.month}",
            () => {
                  _selectDate(context, eduData.startedOn ?? DateTime.now())
                      .then(
                    (valueFromDialog) {
                      setState(
                        () {
                          setState(
                            () {
                              eduData.startedOn = valueFromDialog;
                            },
                          );
                        },
                      );
                    },
                  )
                }),
      );
      listOfEducations.add(const Divider());
      listOfEducations.add(
        getTile(
            context,
            'Finished Date',
            eduData.finishedOn == null
                ? ""
                : "${eduData.finishedOn?.year}.${eduData.finishedOn?.month}",
            () => {
                  _selectDate(context, eduData.finishedOn ?? DateTime.now())
                      .then(
                    (valueFromDialog) {
                      setState(
                        () {
                          setState(
                            () {
                              eduData.finishedOn = valueFromDialog;
                            },
                          );
                        },
                      );
                    },
                  )
                }),
      );
      listOfEducations.add(const Divider(
        thickness: 2,
      ));
    }

    return listOfEducations;
  }
}

class EditSkills extends StatefulWidget {
  const EditSkills(List<SkillData> data, {super.key}) : _data = data;
  final List<SkillData> _data;
  @override
  State<EditSkills> createState() => _EditSkills();
}

class _EditSkills extends State<EditSkills> {
  @override
  initState() {
    super.initState();
    _data = widget._data;
  }

  late List<SkillData> _data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Skills'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _data),
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: widgetListOfSkills(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const Dialog("New Skill", ""),
        ).then(
          (valueFromDialog) {
            if (valueFromDialog != null) {
              setState(
                () {
                  _data.add(SkillData(valueFromDialog));
                },
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> widgetListOfSkills(BuildContext context) {
    List<Widget> listOfSkills = [];
    for (var skillData in _data) {
      listOfSkills.add(ListTile(
        title: Row(
          children: [
            Flexible(
                flex: 3,
                child: Center(
                  child: Text("Skill number ${_data.indexOf(skillData) + 1}"),
                )),
            Flexible(
              flex: 2,
              child: ElevatedButton(
                child: const Text("Remove skill"),
                onPressed: () => {
                  setState(() {
                    _data.remove(skillData);
                  })
                },
              ),
            ),
          ],
        ),
      ));
      listOfSkills.add(const Divider());
      listOfSkills.add(ListTile(
        title: Center(child: Text(skillData.skill)),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog("Skill", skillData.skill),
        ).then(
          (valueFromDialog) {
            if (valueFromDialog != null) {
              setState(
                () {
                  skillData.skill = valueFromDialog;
                },
              );
            }
          },
        ),
      ));
      listOfSkills.add(const Divider(
        thickness: 2,
      ));
    }

    return listOfSkills;
  }
}

class Dialog extends StatefulWidget {
  @override
  State<Dialog> createState() => _DialogState();

  final String field;
  final String? content;

  const Dialog(this.field, this.content, {super.key});
}

class _DialogState extends State<Dialog> {
  String field = "";
  String content = "";
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    field = widget.field;
    content = widget.content ?? "";
    _controller = TextEditingController(text: content);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(field),
      content: TextField(
        maxLines: null,
        controller: _controller,
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

Widget getTile(
    BuildContext context, String filed, String value, void Function()? onTap) {
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
