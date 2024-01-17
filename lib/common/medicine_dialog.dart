// medicine_dialog.dart

import 'package:flutter/material.dart';
import 'package:dispensary/models/medicine_model.dart';

class MedicineDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(Medicine) onAddMedicine;

  MedicineDialog({required this.formKey, required this.onAddMedicine});

  @override
  Widget build(BuildContext context) {
    TextEditingController medicineNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Medication'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: medicineNameController,
                decoration: const InputDecoration(labelText: 'Medicine Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the medicine name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Medicine medicine = Medicine(
                  sysMedicineId: 1,
                  name: 'Aspirin',
                  description: 'Pain reliever',
                  createdDate: DateTime.timestamp(),
                  updatedDate: DateTime.timestamp());
              onAddMedicine(medicine);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
