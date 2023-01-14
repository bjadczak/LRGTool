import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lrgtool/misc/linkedin_data_structs.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreatePDF extends StatelessWidget {
  const CreatePDF(this.data, {super.key});

  final String title = "PDF Demo";
  final CvData data;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: PdfPreview(
          initialPageFormat: PdfPageFormat.a4,
          pageFormats: const {"A4": PdfPageFormat.a4},
          build: (format) => _generatePdf(format, title),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.merriweatherRegular();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Flexible(
                flex: 1,
                child: pw.Container(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Container(
                        child: pw.Text(
                          "${data.profileData.firstName} ${data.profileData.secondName}",
                          style: pw.TextStyle(font: font, fontSize: 36),
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Container(
                        child: pw.Text(
                          "${data.profileData.email} ${data.profileData.email.isNotEmpty && data.profileData.location.isNotEmpty ? "|" : ""} ${data.profileData.location} ${data.profileData.industry.isNotEmpty && data.profileData.location.isNotEmpty || data.profileData.industry.isNotEmpty && data.profileData.email.isNotEmpty ? "|" : ""} ${data.profileData.industry}",
                          style: pw.TextStyle(font: font, fontSize: 18),
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Container(
                        child: pw.Text(
                          data.profileData.headline,
                          style: pw.TextStyle(font: font, fontSize: 18),
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Divider(),
              pw.Flexible(
                flex: 7,
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Flexible(
                      flex: 1,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          // About me
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Text(
                                "About me",
                                style: pw.TextStyle(font: font, fontSize: 24),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Text(
                                data.profileData.summary,
                                style: pw.TextStyle(font: font, fontSize: 18),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ),
                          pw.Spacer(flex: 2),
                          // Education
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Text(
                                "Education",
                                style: pw.TextStyle(font: font, fontSize: 24),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Builder(
                                builder: (context) {
                                  String text = "";
                                  for (var eduData in data.education) {
                                    text += "• ";
                                    text +=
                                        "${eduData.schoolName}\n${eduData.degree} ${eduData.degree.isNotEmpty && eduData.course.isNotEmpty ? "|" : ""} ${eduData.course}${eduData.startedOn == null ? "" : "\n${eduData.startedOn?.year}-${eduData.finishedOn?.year.toString() ?? ""}"}\n";
                                  }
                                  return pw.Text(
                                    text,
                                    style:
                                        pw.TextStyle(font: font, fontSize: 18),
                                    textAlign: pw.TextAlign.left,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.VerticalDivider(),
                    pw.Flexible(
                      flex: 3,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          //Skills
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Text(
                                "Skills",
                                style: pw.TextStyle(font: font, fontSize: 24),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Builder(
                                builder: (context) {
                                  String text = "";
                                  for (var skill in data.skills) {
                                    text += "• ";
                                    text += "${skill.skill}\n";
                                  }
                                  return pw.Text(
                                    text,
                                    style:
                                        pw.TextStyle(font: font, fontSize: 18),
                                    textAlign: pw.TextAlign.left,
                                  );
                                },
                              ),
                            ),
                          ),
                          pw.Spacer(flex: 2),
                          //Prevois positions
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Text(
                                "Previous work expirience",
                                style: pw.TextStyle(font: font, fontSize: 24),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Flexible(
                            flex: 6,
                            child: pw.Container(
                              child: pw.Builder(
                                builder: (context) {
                                  String text = "";
                                  for (var posData in data.positions) {
                                    text += "• ";
                                    text +=
                                        "${posData.companyName} - ${posData.title}\n${posData.description}${posData.startedOn == null ? "" : "\n${posData.startedOn?.year}-${posData.finishedOn?.year.toString() ?? ""}"}\n";
                                  }
                                  return pw.Text(
                                    text,
                                    style:
                                        pw.TextStyle(font: font, fontSize: 18),
                                    textAlign: pw.TextAlign.left,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
