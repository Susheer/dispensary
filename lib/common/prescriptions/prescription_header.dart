import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/common/typography.dart';
import 'package:dispensary/utils.dart/prescriptionUtil.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PrescriptionHeader extends StatelessWidget {
  final int sysPrescriptionId;
  final int patientId;
  final String patientName;
  final String diagnosis;
  final String chiefComplaint;
  final DateTime createdDate;
  final DateTime updatedDate;
  final double totalAmount;
  final double paidAmount;
  final VoidCallback onTap;
  static const TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold);

  PrescriptionHeader({
    required this.sysPrescriptionId,
    required this.patientId,
    required this.patientName,
    required this.diagnosis,
    required this.chiefComplaint,
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
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowWithLabelAndValueSet(
                isOverflow: true,
                label1: 'Prescription:',
                value1: sysPrescriptionId.toString(),
                label2: 'Updated: ',
                value2: timeago.format(createdDate)),
            RowWithLabelAndValueSet(
                isOverflow: true,
                label1: 'Pending Bal:',
                value1: PrescriptionUtil.calPendingBal(totalAmount, paidAmount),
                label2: 'Created: ',
                value2: formatDate(createdDate)),
            Typography2(label: 'Patient Name', value: patientName),
            ...[
              const Text(
                'Chief Complaint:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                chiefComplaint,
              )
            ]
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString().substring(2);

    return '$day/$month/$year';
  }
}
