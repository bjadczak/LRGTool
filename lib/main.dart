import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:file_picker/file_picker.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

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
            ElevatedButton(
              child: const Text('Second screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondRoute()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Test Load file screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdRoute()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Test Zip screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestZip()),
                );
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
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({super.key});
  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickFile();
              },
              child: const Text('Open File'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
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

class TestZip extends StatefulWidget {
  @override
  _MyTestZipApp createState() => _MyTestZipApp();
}

class _MyTestZipApp extends State<TestZip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin test app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _test,
                child: const Text("Test"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              )
            ],
          ),
        ),
      ),
    );
  }

  final _appDataDir = Directory.systemTemp;

  static const _dataFilesBaseDirectoryName = "store";
  final _dataFiles = {
    "file1.txt": "abc",
    "file2.txt": "åäö",
    "subdir1/file3.txt": r"@_£$",
    "subdir1/subdir11/file4.txt": "123",
  };

  Future _test() async {
    print("Start test");
    // test createFromDirectory
    // case 1
    var zipFile = await _testZip(includeBaseDirectory: false, progress: true);
    await _testUnzip(zipFile, zipIncludesBaseDirectory: false);
    await _testUnzip(zipFile, progress: true);
    // case 2
    zipFile = await _testZip(includeBaseDirectory: true, progress: false);
    await _testUnzip(zipFile, zipIncludesBaseDirectory: true);

    // test createFromFiles
    // case 1
    zipFile = await _testZipFiles(includeBaseDirectory: false);
    await _testUnzip(zipFile, zipIncludesBaseDirectory: false);
    // case 2
    zipFile = await _testZipFiles(includeBaseDirectory: true);
    await _testUnzip(zipFile, zipIncludesBaseDirectory: true);

    print("DONE!");
  }

  Future<File> _testZip(
      {required bool includeBaseDirectory, bool progress = false}) async {
    print("_appDataDir=${_appDataDir.path}");
    final storeDir =
        Directory("${_appDataDir.path}${"/$_dataFilesBaseDirectoryName"}");

    _createTestFiles(storeDir);

    final zipFile = _createZipFile("testZip.zip");
    print("Writing to zip file: ${zipFile.path}");

    int onProgressCallCount1 = 0;

    try {
      await ZipFile.createFromDirectory(
        sourceDir: storeDir,
        zipFile: zipFile,
        recurseSubDirs: true,
        includeBaseDirectory: includeBaseDirectory,
        onZipping: progress
            ? (fileName, isDirectory, progress) {
                ++onProgressCallCount1;
                print('Zip #1:');
                print('progress: ${progress.toStringAsFixed(1)}%');
                print('name: $fileName');
                print('isDirectory: $isDirectory');
                return ZipFileOperation.includeItem;
              }
            : null,
      );
      assert(!progress || onProgressCallCount1 > 0);
    } on PlatformException catch (e) {
      print(e);
    }
    return zipFile;
  }

  Future<File> _testZipFiles({required bool includeBaseDirectory}) async {
    print("_appDataDir=${_appDataDir.path}");
    final storeDir =
        Directory("${_appDataDir.path}${"/$_dataFilesBaseDirectoryName"}");

    final testFiles = _createTestFiles(storeDir);

    final zipFile = _createZipFile("testZipFiles.zip");
    print("Writing files to zip file: ${zipFile.path}");

    try {
      await ZipFile.createFromFiles(
          sourceDir: storeDir,
          files: testFiles,
          zipFile: zipFile,
          includeBaseDirectory: includeBaseDirectory);
    } on PlatformException catch (e) {
      print(e);
    }
    return zipFile;
  }

  Future _testUnzip(File zipFile,
      {bool progress = false, bool zipIncludesBaseDirectory = false}) async {
    print("_appDataDir=${_appDataDir.path}");

    final destinationDir = Directory("${_appDataDir.path}/unzip");
    final destinationDir2 = Directory("${_appDataDir.path}/unzip2");

    if (destinationDir.existsSync()) {
      print("Deleting existing unzip directory: ${destinationDir.path}");
      destinationDir.deleteSync(recursive: true);
    }
    if (destinationDir2.existsSync()) {
      print("Deleting existing unzip directory: ${destinationDir2.path}");
      destinationDir2.deleteSync(recursive: true);
    }

    print("Extracting zip to directory: ${destinationDir.path}");
    destinationDir.createSync();
    // test concurrent extraction
    final extractFutures = <Future>[];
    int onExtractingCallCount1 = 0;
    int onExtractingCallCount2 = 0;
    try {
      extractFutures.add(ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir,
          onExtracting: progress
              ? (zipEntry, progress) {
                  ++onExtractingCallCount1;
                  print('Extract #1:');
                  print('progress: ${progress.toStringAsFixed(1)}%');
                  print('name: ${zipEntry.name}');
                  print('isDirectory: ${zipEntry.isDirectory}');
                  print(
                      'modificationDate: ${zipEntry.modificationDate!.toLocal().toIso8601String()}');
                  print('uncompressedSize: ${zipEntry.uncompressedSize}');
                  print('compressedSize: ${zipEntry.compressedSize}');
                  print('compressionMethod: ${zipEntry.compressionMethod}');
                  print('crc: ${zipEntry.crc}');
                  return ZipFileOperation.includeItem;
                }
              : null));

      extractFutures.add(ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir2,
          onExtracting: progress
              ? (zipEntry, progress) {
                  ++onExtractingCallCount2;
                  print('Extract #2:');
                  print('progress: ${progress.toStringAsFixed(1)}%');
                  print('name: ${zipEntry.name}');
                  print('isDirectory: ${zipEntry.isDirectory}');
                  print(
                      'modificationDate: ${zipEntry.modificationDate!.toLocal().toIso8601String()}');
                  print('uncompressedSize: ${zipEntry.uncompressedSize}');
                  print('compressedSize: ${zipEntry.compressedSize}');
                  print('compressionMethod: ${zipEntry.compressionMethod}');
                  print('crc: ${zipEntry.crc}');
                  return ZipFileOperation.includeItem;
                }
              : null));

      await Future.wait<void>(extractFutures);
      assert(onExtractingCallCount1 == onExtractingCallCount2);
      assert(!progress || onExtractingCallCount1 > 0);
    } on PlatformException catch (e) {
      print(e);
    }

    // verify unzipped files
    if (zipIncludesBaseDirectory) {
      _verifyFiles(
          Directory("${destinationDir.path}/$_dataFilesBaseDirectoryName"));
      _verifyFiles(
          Directory("${destinationDir2.path}/$_dataFilesBaseDirectoryName"));
    } else {
      _verifyFiles(destinationDir);
      _verifyFiles(destinationDir2);
    }
  }

  File _createZipFile(String fileName) {
    final zipFilePath = "${_appDataDir.path}/$fileName";
    final zipFile = File(zipFilePath);

    if (zipFile.existsSync()) {
      print("Deleting existing zip file: ${zipFile.path}");
      zipFile.deleteSync();
    }
    return zipFile;
  }

  List<File> _createTestFiles(Directory storeDir) {
    if (storeDir.existsSync()) {
      storeDir.deleteSync(recursive: true);
    }
    storeDir.createSync();
    final files = <File>[];
    for (final fileName in _dataFiles.keys) {
      final file = File("${storeDir.path}/$fileName");
      file.createSync(recursive: true);
      print("Writing file: ${file.path}");
      file.writeAsStringSync(_dataFiles[fileName]!);
      files.add(file);
    }

    // verify created files
    _verifyFiles(storeDir);

    return files;
  }

  void _verifyFiles(Directory filesDir) {
    print("Verifying files at: ${filesDir.path}");
    final extractedItems = filesDir.listSync(recursive: true);
    for (final item in extractedItems) {
      print("extractedItem: ${item.path}");
    }
    print("File count: ${extractedItems.length}");
    assert(extractedItems.whereType<File>().length == _dataFiles.length,
        "Invalid number of files");
    for (final fileName in _dataFiles.keys) {
      final file = File('${filesDir.path}/$fileName');
      print("Verifying file: ${file.path}");
      assert(file.existsSync(), "File not found: ${file.path}");
      final content = file.readAsStringSync();
      assert(content == _dataFiles[fileName],
          "Invalid file content: ${file.path}");
    }
    print("All files ok");
  }
}
