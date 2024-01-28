import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class PDFPrescription extends StatelessWidget {
  String nameOfDocter = "Dr. Varun, MBBS, MD";
  String nameOfClinic = "Dr. D. Y. Patil Vidyapeeth, Pune";
  String addressLine1 = "(Deemed to be University)";
  String addressLine2 = "Sant Tukaram Nagar";
  String addressLine3 = "Pimpri, Pune 411018";
  String regNO = "Regd. No. 03302441";

  String nameOfPatient = "Subham lahari";
  String age = "29 years";
  String addressOfPatient = "Pimpri, Pune 411018";
  String dateOfConsultation = DateFormat('dd/MM/yyyy').format(DateTime.now());

  double typo15FontSize = 15;
  double typo20FontSize = 20;
  double typo30FontSize = 30;
  double typo40FontSize = 40.0;
  double typo50FontSize = 50;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PDF Prescription'),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nameOfDocter,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: typo30FontSize)),
                          Text(nameOfClinic,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: typo20FontSize)),
                          Text(addressLine1,
                              style: TextStyle(fontSize: typo15FontSize)),
                          Text(addressLine2,
                              style: TextStyle(fontSize: typo15FontSize)),
                          Text(addressLine3,
                              style: TextStyle(fontSize: typo15FontSize)),
                          Text(regNO,
                              style: TextStyle(fontSize: typo15FontSize)),
                        ],
                      ),
                    ],
                  ),
                  // Divider
                  const SizedBox(height: 40),
                  // Body
                  // Patient details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              const Text('Name of Patient ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(nameOfPatient),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: [
                              const Text('Age ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(age),
                            ],
                          ),
                        ],
                      ),
                      // second line
                      Row(
                        children: [
                          Row(
                            children: [
                              const Text('Address of Patient ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(addressOfPatient),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: [
                              const Text('Date of consultation ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(dateOfConsultation),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  // Divider
                  const SizedBox(height: 20),
                  // Medication table
                  buildHeader(),
                  _buildTableRow(
                      'Medicine 1', '2 times a day', '10 mg', 'Take with food'),
                  _buildTableRow(
                      'Medicine 2', 'Once a day', '20 mg', 'Before bedtime'),
                  _buildTableRow(
                      'Medicine 3', '3 times a day', '15 mg', 'After meals'),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Generate the PDF
                  final pdf = generatePDF();
                  // Allow user to pick location to save the PDF file
                  pickLocationToSavePDF(pdf);
                },
                child: Text('Generate Prescription PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text('Medicine Name',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: Text('Doses', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child:
              Text('Strength', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  pw.Row pw_buildHeader() {
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

  Widget _buildTableRow(
      String medicineName, String doses, String strength, String notes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(medicineName),
          ),
          Expanded(
            flex: 2,
            child: Text(doses),
          ),
          Expanded(
            flex: 2,
            child: Text(strength),
          ),
          Expanded(
            flex: 3,
            child: Text(notes),
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
                              fontSize: typo30FontSize)),
                      pw.Text(nameOfClinic,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: typo20FontSize)),
                      pw.Text(addressLine1,
                          style: pw.TextStyle(fontSize: typo15FontSize)),
                      pw.Text(addressLine2,
                          style: pw.TextStyle(fontSize: typo15FontSize)),
                      pw.Text(addressLine3,
                          style: pw.TextStyle(fontSize: typo15FontSize)),
                      pw.Text(regNO,
                          style: pw.TextStyle(fontSize: typo15FontSize)),
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
                          pw.Text('Name of Patient ',
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
                          pw.Text('Age ',
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
                          pw.Text('Address of Patient ',
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
                          pw.Text('Date of consultation ',
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
              pw_buildHeader(),
              _pwBuildTableRow(
                  'Medicine 1', '2 times a day', '10 mg', 'Take with food'),
              _pwBuildTableRow(
                  'Medicine 2', 'Once a day', '20 mg', 'Before bedtime'),
              _pwBuildTableRow(
                  'Medicine 3', '3 times a day', '15 mg', 'After meals'),
            ],
          ),
        ),
      ],
    );
  }

  pw.Document generatePDF() {
    // Create a new PDF document
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return createPageContent();
    }));

    return pdf;
  }

  Future<void> pickLocationToSavePDF(pw.Document pdf) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      // User canceled the picker
      debugPrint("selectedDirectory $selectedDirectory");
    } else {
      debugPrint("ser canceled the picker $selectedDirectory");
    }
    // Prompt user to select directory
    //Directory? directory = await getExternalStorageDirectory();
    if (selectedDirectory != null) {
      String directoryPath = selectedDirectory;

      // Construct file path for the PDF
      String filePath =
          '$directoryPath/p-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.pdf';

      // Save the PDF document to the chosen location
      final bytes = await pdf.save();
      File(filePath).writeAsBytes(bytes);
      print('PDF saved successfully at: $filePath');
    } else {
      // Failed to retrieve directory
      print('Failed to retrieve directory.');
    }
  }
}
