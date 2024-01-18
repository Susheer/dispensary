import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicationForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  List<Medicine> medicines;
  List<String> dosesValues = [
    '0-0-0',
    '0-0-1',
    '0-1-0',
    '0-1-1',
    '1-0-0',
    '1-0-1',
    '1-1-0',
    '1-1-1',
  ];
  MedicationForm(this.onSave, this.medicines);

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  late AutoCompleteTextField<Medicine>? medicineNameTextField;
  late AutoCompleteTextField<String>? dosesTextField;
  TextEditingController nameController = TextEditingController();
  TextEditingController dosesController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String selectedValue = '0-0-0';
  bool listLoaded = false;
  final GlobalKey<AutoCompleteTextFieldState<Medicine>> medicineNameKey =
      GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<String>> dosesTextFieldKey =
      GlobalKey();

  @override
  void initState() {
    super.initState();
    medicineNameTextField = AutoCompleteTextField<Medicine>(
      key: medicineNameKey,
      clearOnSubmit: false,
      controller: nameController,
      suggestions: widget.medicines,
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
    dosesTextField = AutoCompleteTextField<String>(
      key: dosesTextFieldKey,
      clearOnSubmit: false,
      controller: dosesController,
      suggestions: widget.dosesValues,
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: const InputDecoration(
        labelText: 'Doses',
      ),
      itemFilter: (item, query) {
        return item.toLowerCase().contains(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.compareTo(b);
      },
      itemSubmitted: (item) {
        print('Itemmmm${item}');
        dosesController.text = item;
        return item;
        // Handle selected item
      },
      itemBuilder: (context, item) {
        return ListTile(
          title: Text(item),
        );
      },
    );
  }

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
            medicineNameTextField ?? const SizedBox(height: 16),
            dosesTextField ?? const SizedBox(height: 16),
            TextFormField(
              controller: strengthController,
              decoration: const InputDecoration(labelText: 'Strength'),
            ),
            TextFormField(
              controller: notesController,
              decoration:
                  const InputDecoration(labelText: 'Notes ex. As needed'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> formData = {
                      'medicineName': medicineNameTextField?.controller?.text,
                      'doses': dosesController.text,
                      'duration': durationController.text,
                      'strength': strengthController.text,
                      'notes': notesController.text,
                    };
                    widget.onSave(formData);
                  },
                  child: const Text('Add Medication'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
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
