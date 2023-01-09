import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lrgtool/linkedin_data_structs.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'load_data_screen.dart';
import 'edit_data_screen.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CvData? _cvData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadFromZipOrClear(context),
            ElevatedButton(
              child: const Text('Edit data screen'),
              onPressed: () {
                launchEditData(context);
              },
            ),
            ElevatedButton(
              child: const Text('Test PDF screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: 'Flutter Demo Home Page')),
                );
              },
            )
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
      _cvData = result;
    });
  }

  ElevatedButton loadFromZipOrClear(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Unavilable on web'),
    );

    return _cvData == null && _cvData != CvData.empty()
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Hello World!'),
        ),
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => {
          await Printing.sharePdf(
              bytes: await _generatePdf(), filename: 'my-document.pdf')
        },
        tooltip: 'Generate PDF',
        child: const Text("PDF"),
      ),
    );
  }
}
