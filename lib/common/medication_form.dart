import 'package:flutter/material.dart';

class MedicationForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  MedicationForm(this.onSave);

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController dosesController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Medication',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: medicineNameController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
            ),
            TextFormField(
              controller: dosesController,
              decoration: const InputDecoration(labelText: 'Doses'),
            ),
            TextFormField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
            TextFormField(
              controller: strengthController,
              decoration: const InputDecoration(labelText: 'Strength'),
            ),
            TextFormField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> formData = {
                  'medicineName': medicineNameController.text,
                  'doses': dosesController.text,
                  'duration': durationController.text,
                  'strength': strengthController.text,
                  'notes': notesController.text,
                };
                widget.onSave(formData);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
