import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:dispensary/services/prescription_pdf.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'prescription_header.dart';
import 'prescription_body.dart';

class PrescriptionWidget extends StatefulWidget {
  final int sysPrescriptionId;
  final int patientId;
  final String patientName;
  final String diagnosis;
  final String chiefComplaint;
  final DateTime createdDate;
  final DateTime updatedDate;
  final double totalAmount;
  final double paidAmount;

  final List<PrescriptionLine> lines;

  PrescriptionWidget(
      {required this.sysPrescriptionId,
      required this.patientId,
      required this.diagnosis,
      required this.chiefComplaint,
      required this.patientName,
      required this.createdDate,
      required this.updatedDate,
      required this.totalAmount,
      required this.paidAmount,
      required this.lines});

  @override
  _PrescriptionWidgetState createState() => _PrescriptionWidgetState();
}

class _PrescriptionWidgetState extends State<PrescriptionWidget> {
  bool isBodyVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(4),
      child: Card(
        child: Column(
          children: [
            PrescriptionHeader(
              sysPrescriptionId: widget.sysPrescriptionId,
              patientName: widget.patientName,
              patientId: widget.patientId,
              diagnosis: widget.diagnosis,
              chiefComplaint: widget.chiefComplaint,
              createdDate: widget.createdDate,
              updatedDate: widget.updatedDate,
              totalAmount: widget.totalAmount,
              paidAmount: widget.paidAmount,
              onTap: () {},
            ),
            if (isBodyVisible)
              PrescriptionBody(
                medicalDignosis: widget.diagnosis,
                prescriptionLines:
                    widget.lines, // Pass the prescriptionLines data
              ),
            const Separator(),
            buildActionButtonsRow(context),
          ],
        ),
      ),
    );
  }

  Widget buildActionButtonsRow(BuildContext context) {
    return Container(
      // decoration:
      //     BoxDecoration(border: Border.all(color: Colors.blueGrey, width: 1)),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, maxHeight: 40),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        if (isBodyVisible == true)
          IconButton(
            icon: const Icon(Icons.arrow_drop_up),
            tooltip: "Hide medications",
            onPressed: toggleMedicationButton,
          ),
        if (isBodyVisible == false)
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            tooltip: "Show Medications",
            onPressed: toggleMedicationButton,
          ),
        IconButton(
          icon: const Icon(
            Icons.share_rounded,
            size: 16,
          ),
          tooltip: "Share",
          onPressed: () async {
            PDFPrescription doc = PDFPrescription(
                presLine: widget.lines,
                addressOfPatient: "patient addgh jjj",
                age: '22',
                dateOfConsultation:
                    DateFormat('dd/MM/yyyy').format(widget.createdDate),
                nameOfPatient: widget.patientName);
            await doc.downloadPrescription(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit_document, size: 17),
          tooltip: "Edit Medication",
          onPressed: () {
            showAlert(message: 'Edit Medication');
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_balance_wallet, size: 17),
          tooltip: "Edit Balance",
          onPressed: () {
            showAlert(message: 'Edit Balance');
          },
        )
      ]),
    );
  }

  void showAlert({String message = ""}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void toggleMedicationButton() {
    setState(() {
      isBodyVisible = !isBodyVisible;
    });
  }
}
