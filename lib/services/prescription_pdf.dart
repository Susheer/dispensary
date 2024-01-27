import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class PDFPrescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Prescription'),
        ),
        body: Center(
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
      ),
    );
  }

  pw.Document generatePDF() {
    // Create a new PDF document
    final pdf = pw.Document();

    // Add content to the PDF document...

    return pdf;
  }

  // Future<void> pickLocationToSavePDF(pw.Document pdf) async {
  //   // Allow user to pick location to save the file
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );

  //   if (result != null) {
  //     // Extract file path from result
  //     String filePath = result.files.single.path!;

  //     // Save the PDF document to the chosen location
  //     final bytes = await pdf.save();
  //     File(filePath).writeAsBytes(bytes);
  //     print('PDF saved successfully at: $filePath');
  //   } else {
  //     // User canceled the file picking operation
  //     print('User canceled the operation.');
  //   }
  // }

  Future<void> pickLocationToSavePDF(pw.Document pdf) async {
    // Prompt user to select directory
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String directoryPath = directory.path;

      // Construct file path for the PDF
      String filePath = '$directoryPath/prescription.pdf';

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
