import 'dart:io';
import 'package:dispensary/appConfig.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class PDFPrescription {
  String nameOfDocter = AppConfig.nameOfDocter;
  String nameOfClinic = AppConfig.nameOfClinic;
  String addressLine1 = AppConfig.addressLine1;
  String addressLine2 = AppConfig.addressLine2;
  String addressLine3 = AppConfig.addressLine3;
  String regNO = AppConfig.regNO;
  String degree = AppConfig.degree;
  String position = AppConfig.position;
  String clinicMobile = AppConfig.clinicMobile;
  
  

  String nameOfPatient;
  String age;
  String addressOfPatient;
  String dateOfConsultation = DateFormat('dd/MM/yyyy').format(DateTime.now());

  double typo15FontSize = 15;
  double typo20FontSize = 20;
  double typo30FontSize = 30;
  double typo40FontSize = 40.0;
  double typo50FontSize = 50;
  pw.Document? pdf;
  List<PrescriptionLine> presLine;

  PDFPrescription({required this.presLine, required this.nameOfPatient, required this.age, required this.addressOfPatient, required this.dateOfConsultation}) {
    pdf = pw.Document(
        pageMode: PdfPageMode.fullscreen,
        version: PdfVersion.pdf_1_5,
        author: AppConfig.prescriptionPDFAuther,
        creator: AppConfig.creator,
        producer: AppConfig.prescriptionPDFAuther,
        title: 'Prescription-$nameOfPatient',
        subject: 'This Prescription is not valid without seal.');
  }

  Future<void> downloadPrescription(BuildContext ctx) async {
    debugPrint("downloadPrescription invoked");
    final pdf = generatePDF();
    final location = await pickLocationToSavePDF();
    if (location != null) await savePDF(pdf, location, ctx);
  }

  Future<void> share(BuildContext ctx) async {
    debugPrint("share invoked");
    final pdf = generatePDF();
    final location = await appLocation();
    if (location != null) await sharePDF(pdf, location, ctx);
  }

  pw.Row _pwBuildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Text('Medicine Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text('Doses', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text('Strength', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Text('Notes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
      ],
    );
  }

  pw.Widget _pwBuildTableRow(String medicineName, String doses, String strength, String notes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Text(medicineName),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(doses),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(strength),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(notes),
          ),
        ],
      ),
    );
  }

  pw.Column createPageContent() {
    return pw.Column(
      children: [
        pw.Container(
          //decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.red, width: 1)),
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        // decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.red, width: 1)),
                        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                          pw.Text(nameOfDocter, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: typo30FontSize)),
                          pw.Row(
                            mainAxisSize: pw.MainAxisSize.min,
                            children: [pw.Text('$degree ', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(regNO, textAlign: pw.TextAlign.right)],
                          )
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text(position, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: typo15FontSize)),
              ]),
              Seperator(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                //left side data
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(nameOfClinic, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(addressLine1),
                  pw.Text(addressLine2),
                  pw.Text(clinicMobile),
                ]),
                // right side data
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text('Time: Mon to Sat'),
                  pw.Text('Mor. 10.00 to 1:30,  Eve. 60:00 to 10:30'),
                  pw.Text('Sunday Morning only', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]),
              ]),
              Seperator(),
              // Divider
              pw.SizedBox(height: 6),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [pw.Text('Date: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(dateOfConsultation)]),

              pw.Row(
                children: [
                  pw.Text('Patient Name: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(nameOfPatient),
                ],
              ),
              pw.Row(
                        children: [
                  pw.Text('Patient Age: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(age),
                        ],
              ),
              pw.Row(
                children: [
                  pw.Text('Address: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(addressOfPatient),
                        ],
                      ),
              
            
              // Divider
              pw.SizedBox(height: 30),
              pw.Container(
                  //decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.red, width: 1)),
                  child: pw.Column(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [_pwBuildHeader(), ...presLine.map((line) => _pwBuildTableRow(line.medicine.name, line.doses, line.strength, line.notes)).toList()],
              ))
              
              // Medication table
             
            ],
          ),
        ),
      ],
    );
  }

  pw.Document generatePDF() {
    if (pdf != null) {
      pdf!.addPage(pw.Page(build: (pw.Context context) {
        return createPageContent();
      }));
    } else {
      pdf = pw.Document();
    }

    return pdf!;
  }

  Future<String?> pickLocationToSavePDF() async {
    Directory? download;
    if (Platform.isAndroid == true) {
      debugPrint("88888888888 Platform.isAndroid:${Platform.isAndroid} 88888888888");
      download = Directory('/storage/emulated/0/Download');
      if (!await download.exists()) {
        download = await getDownloadsDirectory();
      }
    } else if (Platform.isWindows == true) {
      debugPrint("88888888888 Platform.isWindows:${Platform.isWindows} 88888888888");
      download = await getDownloadsDirectory();
    } else if (Platform.isIOS) {
      debugPrint("88888888888 Platform.isIOS:${Platform.isIOS} 88888888888");
      download = await getExternalStorageDirectory();
    }

    if (download != null) {
      debugPrint("-----------------------------------");
      debugPrint("Download path ${download.path}");
      debugPrint("-----------------------------------");
      return download.path;
    }
    return null;
  }

  Future<String?> appLocation() async {
    Directory? appDir = await getApplicationDocumentsDirectory();
    if (appDir != null) {
      return appDir.path;
    }
    return null;
  }

  Future<void> savePDF(pw.Document pdf, String directoryPath, BuildContext ctx) async {
    String filePath = '$directoryPath/p-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.pdf';
    final bytes = await pdf.save();
    File file = await File(filePath);
    file.createSync(recursive: true);
    await file.writeAsBytes(bytes);
    showSnackbar(ctx, 'Downloaded: ${filePath}');
    debugPrint('PDF saved successfully at: $filePath');
  }

  Future<void> sharePDF(pw.Document pdf, String directoryPath, BuildContext ctx) async {
    String filePath = '$directoryPath/prescription-${DateTime.now().toIso8601String()}.pdf'.toLowerCase();
    final bytes = await pdf.save();
    final file = await File(filePath).create(recursive: true);
    await file.writeAsBytes(bytes);
    XFile ff = XFile(filePath);
    if (file.existsSync() == true) {
      debugPrint("----------This is inside----------");
      ShareResult result = await Share.shareXFiles([ff], subject: '$nameOfClinic | Prescription-$nameOfPatient');
      debugPrint("-------<<<<<<<---After Share result -->>>>>>>>--------");
      debugPrint("Share result.status ${result.status}");
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }
    }
  }

  void showSnackbar(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  pw.Container Seperator({double height = 1.0, PdfColor color = PdfColors.black}) {
    return pw.Container(height: height, color: color, margin: const pw.EdgeInsets.symmetric(vertical: 2));
  }
}
