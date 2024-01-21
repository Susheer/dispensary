import 'package:dispensary/providers/medicine_provider.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:provider/provider.dart';

class NewMedicineScreen extends StatefulWidget {
  @override
  _NewMedicineScreenState createState() => _NewMedicineScreenState();
}

class _NewMedicineScreenState extends State<NewMedicineScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? onValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter detail.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a New Medicine',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Medicine Name'),
                validator: onValidate,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: onValidate,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  Medicine newMedicine = Medicine(
                    sysMedicineId: 0, // Replace with actual ID if applicable
                    name: nameController.text,
                    description: descriptionController.text,
                    createdDate: DateTime.now(),
                    updatedDate: DateTime.now(),
                  );
                  if (_formKey.currentState!.validate()) {
                    await Provider.of<MedicineProvider>(context, listen: false)
                        .insertMedicine(newMedicine);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New medicine added.'),
                      ),
                    );
                    Future.delayed(Duration(seconds: 2));
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fill all the details'),
                      ),
                    );
                  }
                },
                child: const Text('Add Medicine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
