import 'package:flutter/material.dart';

class EditMedicineBottomSheet extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  EditMedicineBottomSheet({required this.initialData, required this.onSave});

  @override
  _EditMedicineBottomSheetState createState() =>
      _EditMedicineBottomSheetState();
}

class _EditMedicineBottomSheetState extends State<EditMedicineBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the initial values
    nameController.text = widget.initialData['name'] ?? '';
    descriptionController.text = widget.initialData['description'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Edit Medicine',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Medicine Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a medicine name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the updated values to a map
                      final Map<String, dynamic> updatedData = {
                        'name': nameController.text,
                        'description': descriptionController.text,
                      };
                      // Call the callback function to return the updated map
                      widget.onSave(updatedData);
                      // Close the bottom sheet
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
