import 'package:flutter/material.dart';

class PrescriptionLineCard extends StatelessWidget {
  final String medicineName;
  final String doses;
  final String duration;
  final String notes;
  final String strength;

  const PrescriptionLineCard({
    required this.medicineName,
    required this.doses,
    required this.duration,
    required this.notes,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medicine: $medicineName'),
            Text('Doses: $doses'),
            Text('Duration: $duration'),
            Text('Notes: $notes'),
            Text('Strength: $strength'),
          ],
        ),
      ),
    );
  }
}
