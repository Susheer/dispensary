import 'package:dispensary/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/models/medicine_model.dart';

class AddPrescriptionScreen extends StatefulWidget {
  Patient patient;
  AddPrescriptionScreen({required this.patient});
  @override
  _AddPrescriptionScreenState createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  int _currentStep = 0;
  TextEditingController detailsController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController problemController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController remainingAmountController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();

  List<PrescriptionLine> prescriptionLines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Prescription'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            // Save prescription data and navigate away (you can replace this logic)
            savePrescriptionData();
            Navigator.pop(context);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Prescription Details'),
            content: Column(
              children: [
                TextFormField(
                  controller: detailsController,
                  decoration: InputDecoration(labelText: 'Details'),
                ),
                TextFormField(
                  controller: diagnosisController,
                  decoration: InputDecoration(labelText: 'Diagnosis'),
                ),
                TextFormField(
                  controller: problemController,
                  decoration: InputDecoration(labelText: 'Problem'),
                ),
                TextFormField(
                  controller: totalAmountController,
                  decoration: InputDecoration(labelText: 'Total Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: remainingAmountController,
                  decoration: InputDecoration(labelText: 'Remaining Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: paidAmountController,
                  decoration: InputDecoration(labelText: 'Paid Amount'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          Step(
            title: Text('Add Medications'),
            content: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddMedicationBottomSheet(context);
                  },
                  child: Text('Add Medications'),
                ),
                SizedBox(height: 10),
                if (prescriptionLines.isNotEmpty)
                  Text('Prescription Lines:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                for (var line in prescriptionLines)
                  ListTile(
                    title: Text(line.medicine.name),
                    subtitle: Text('${line.doses} | ${line.duration}'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMedicationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddMedicationForm((formData) {
          setState(() {
            prescriptionLines.add(PrescriptionLine(
              sysPrescriptionLineId: prescriptionLines.length + 1,
              medicine: Medicine(
                sysMedicineId: 0, // Replace with actual medicine ID
                name: formData['medicineName'],
                description: '',
                createdDate: DateTime.now(),
                updatedDate: DateTime.now(),
              ),
              doses: formData['doses'],
              duration: formData['duration'],
              notes: formData['notes'],
              strength: formData['strength'],
            ));
          });
          Navigator.pop(context);
        });
      },
    );
  }

  void savePrescriptionData() {
    // Implement logic to save prescription data
    // Access data using controllers: detailsController.text, diagnosisController.text, etc.
    // Also, use the prescriptionLines list to access medication data
  }
}

class AddMedicationForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  AddMedicationForm(this.onSave);

  @override
  _AddMedicationFormState createState() => _AddMedicationFormState();
}

class _AddMedicationFormState extends State<AddMedicationForm> {
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController dosesController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Medication',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: medicineNameController,
            decoration: InputDecoration(labelText: 'Medicine Name'),
          ),
          TextFormField(
            controller: dosesController,
            decoration: InputDecoration(labelText: 'Doses'),
          ),
          TextFormField(
            controller: durationController,
            decoration: InputDecoration(labelText: 'Duration'),
          ),
          TextFormField(
            controller: strengthController,
            decoration: InputDecoration(labelText: 'Strength'),
          ),
          TextFormField(
            controller: notesController,
            decoration: InputDecoration(labelText: 'Notes'),
          ),
          SizedBox(height: 16),
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
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
