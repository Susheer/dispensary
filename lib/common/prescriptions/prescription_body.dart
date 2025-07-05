import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:flutter/material.dart';

class PrescriptionBody extends StatelessWidget {
  final List<PrescriptionLine> prescriptionLines;
  final String medicalDignosis;

  const PrescriptionBody({required this.prescriptionLines, required this.medicalDignosis});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          const Separator(),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Medical Diagnosis:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            medicalDignosis,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Medication Lines:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...prescriptionLines.map(
            (line) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text('${line.medicine.name}${line.strength == null ? "" : "-" + line.strength} '),
                subtitle: Container(
                  padding: const EdgeInsets.only(left: 8),
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('${line.doses} | ${line.duration}'), Text('Notes: ${line.notes}')],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
