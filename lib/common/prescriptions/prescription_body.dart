import 'package:dispensary/common/prescriptions/prescription_line_card.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:flutter/material.dart';

class PrescriptionBody extends StatelessWidget {
  final List<PrescriptionLine> prescriptionLines;

  PrescriptionBody({required this.prescriptionLines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prescription Lines:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...prescriptionLines.map(
          (line) => PrescriptionLineCard(
            medicineName: line.medicine.name,
            doses: line.doses,
            duration: line.duration,
            notes: line.notes,
            strength: line.strength,
          ),
        ),
      ],
    );
  }
}
