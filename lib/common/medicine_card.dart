import 'package:flutter/material.dart';
import 'package:dispensary/models/medicine.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  MedicineCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicine.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Dosage: ${medicine.dosage}'),
            Text('Strength: ${medicine.strength}'),
            if (medicine.description != null)
              Text('Description: ${medicine.description}'),
            if (medicine.price != null)
              Text('Price: \$${medicine.price!.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
