import 'package:dispensary/models/prescription_line_model.dart';
import 'package:flutter/material.dart';
import 'prescription_header.dart';
import 'prescription_body.dart';

class PrescriptionWidget extends StatefulWidget {
  final int sysPrescriptionId;
  final int patientId;
  final String details;
  final String diagnosis;
  final String problem;
  final DateTime createdDate;
  final DateTime updatedDate;
  final double totalAmount;
  final double paidAmount;
  final List<PrescriptionLine> lines;

  PrescriptionWidget(
      {required this.sysPrescriptionId,
      required this.patientId,
      required this.details,
      required this.diagnosis,
      required this.problem,
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
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          PrescriptionHeader(
            sysPrescriptionId: widget.sysPrescriptionId,
            patientId: widget.patientId,
            details: widget.details,
            diagnosis: widget.diagnosis,
            problem: widget.problem,
            createdDate: widget.createdDate,
            updatedDate: widget.updatedDate,
            totalAmount: widget.totalAmount,
            paidAmount: widget.paidAmount,
            onTap: () {
              setState(() {
                isBodyVisible = !isBodyVisible;
              });
            },
          ),
          if (isBodyVisible)
            PrescriptionBody(
              prescriptionLines:
                  widget.lines, // Pass the prescriptionLines data
            ),
        ],
      ),
    );
  }
}
