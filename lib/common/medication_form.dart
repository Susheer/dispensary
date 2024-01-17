import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:flutter/material.dart';

class MedicationForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const MedicationForm(this.onSave);

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  late AutoCompleteTextField<Medicine> medicineNameTextField;
  TextEditingController nameController = TextEditingController();
  TextEditingController dosesController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final GlobalKey<AutoCompleteTextFieldState<Medicine>> key = GlobalKey();

  List<Medicine> medicineList =
      generateDummyMedicines(); // Replace with actual data from the Medicine table

  @override
  void initState() {
    super.initState();
    medicineNameTextField = AutoCompleteTextField<Medicine>(
      key: key,
      clearOnSubmit: false,
      controller: nameController,
      suggestions: medicineList,
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: const InputDecoration(
        labelText: 'Medicine Name',
      ),
      itemFilter: (item, query) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.name.compareTo(b.name);
      },
      itemSubmitted: (item) {
        print('Itemmmm${item.name}');
        nameController.text = item.name;
        return item.name;
        // Handle selected item
      },
      itemBuilder: (context, item) {
        return ListTile(
          title: Text(item.name),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          medicineNameTextField,
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
                'medicineName': medicineNameTextField.controller?.text,
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
    );
  }
}

List<Medicine> generateDummyMedicines() {
  List<Medicine> dummyMedicines = [];

  for (int i = 1; i <= 500; i++) {
    dummyMedicines.add(
      Medicine(
        sysMedicineId: i,
        name: 'Medicine $i',
        description: 'Description for Medicine $i',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
    );
  }

  return dummyMedicines;
}

List<Medicine> dummyMedicines = [
  Medicine(
    sysMedicineId: 1,
    name: 'Aspirin',
    description: 'Pain reliever',
    createdDate: DateTime.now(),
    updatedDate: DateTime.now(),
  ),
  Medicine(
    sysMedicineId: 2,
    name: 'Paracetamol',
    description: 'Fever reducer',
    createdDate: DateTime.now(),
    updatedDate: DateTime.now(),
  ),
  Medicine(
    sysMedicineId: 3,
    name: 'Ibuprofen',
    description: 'Anti-inflammatory',
    createdDate: DateTime.now(),
    updatedDate: DateTime.now(),
  ),
  // Add more dummy medicines as needed
];
