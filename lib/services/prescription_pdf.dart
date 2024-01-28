import 'dart:io';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class PDFPrescription {
  String nameOfDocter = "Dr. Varun, MBBS, MD";
  String nameOfClinic = "Dr. D. Y. Patil Vidyapeeth, Pune";
  String addressLine1 = "(Deemed to be University)";
  String addressLine2 = "Sant Tukaram Nagar";
  String addressLine3 = "Pimpri, Pune 411018";
  String regNO = "Regd. No. 03302441";

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

  PDFPrescription(
      {required this.presLine,
      required this.nameOfPatient,
      required this.age,
      required this.addressOfPatient,
      required this.dateOfConsultation}) {
    pdf = pw.Document();
  }

  Future<void> downloadPrescription() async {
    debugPrint("downloadPrescription invoked");
    final pdf = generatePDF();
    final location = await pickLocationToSavePDF();
    if (location != null) await savePDF(pdf, location);
  }

  pw.Row _pwBuildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Text('Medicine Name',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text('Doses',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text('Strength',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Text('Notes',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
      ],
    );
  }

  pw.Widget _pwBuildTableRow(
      String medicineName, String doses, String strength, String notes) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4.0),
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
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(nameOfDocter,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: typo20FontSize)),
                      pw.Text(nameOfClinic,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: typo15FontSize)),
                      pw.Text(addressLine1,
                          style: pw.TextStyle(fontSize: typo15FontSize)),
                      pw.Text(addressLine2, style: pw.TextStyle(fontSize: 12)),
                      pw.Text(addressLine3, style: pw.TextStyle(fontSize: 12)),
                      pw.Text(regNO, style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              // Divider
              pw.SizedBox(height: 40),
              // Body
              // Patient details
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Row(
                        children: [
                          pw.Text('Name of Patient: ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(nameOfPatient),
                        ],
                      ),
                      pw.SizedBox(
                        width: 20,
                      ),
                      pw.Row(
                        children: [
                          pw.Text('Age: ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(age),
                        ],
                      ),
                    ],
                  ),
                  // second line
                  pw.Row(
                    children: [
                      pw.Row(
                        children: [
                          pw.Text('Address of Patient: ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(addressOfPatient),
                        ],
                      ),
                      pw.SizedBox(
                        width: 20,
                      ),
                      pw.Row(
                        children: [
                          pw.Text('Date of consultation: ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(dateOfConsultation),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              // Divider
              pw.SizedBox(height: 20),
              // Medication table
              _pwBuildHeader(),
              ...presLine
                  .map((line) => _pwBuildTableRow(line.medicine.name,
                      line.doses, line.strength, line.notes))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }

  pw.Document generatePDF() {
    // Add a page to the PDF
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
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    return selectedDirectory;
  }

  Future<void> savePDF(pw.Document pdf, String directoryPath) async {
    // Prompt user to select directory
    //Directory? directory = await getExternalStorageDirectory();
    // Construct file path for the PDF
    String filePath =
        '$directoryPath/p-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.pdf';
    // Save the PDF document to the chosen location
    final bytes = await pdf.save();
    File(filePath).writeAsBytes(bytes);
    debugPrint('PDF saved successfully at: $filePath');
  }
}
