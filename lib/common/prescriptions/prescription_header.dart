import 'package:flutter/material.dart';

class PrescriptionHeader extends StatelessWidget {
  final int sysPrescriptionId;
  final int patientId;
  final String details;
  final String diagnosis;
  final String problem;
  final DateTime createdDate;
  final DateTime updatedDate;
  final double totalAmount;
  final double paidAmount;
  final VoidCallback onTap;

  PrescriptionHeader({
    required this.sysPrescriptionId,
    required this.patientId,
    required this.details,
    required this.diagnosis,
    required this.problem,
    required this.createdDate,
    required this.updatedDate,
    required this.totalAmount,
    required this.paidAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prescription ID: $sysPrescriptionId'),
            Text('Patient ID: $patientId'),
            Text('Details: $details'),
            Text('Diagnosis: $diagnosis'),
            Text('Problem: $problem'),
            Text('Created Date: ${createdDate.toLocal()}'),
            Text('Updated Date: ${updatedDate.toLocal()}'),
            Text('Total Amount: $totalAmount'),
            Text('Paid Amount: $paidAmount'),
          ],
        ),
      ),
    );
  }
}
