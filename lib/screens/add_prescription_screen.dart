import 'package:dispensary/common/medication_form.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:provider/provider.dart';

class AddPrescriptionScreen extends StatefulWidget {
  Patient patient;
  AddPrescriptionScreen({required this.patient});
  @override
  _AddPrescriptionScreenState createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  int _currentStep = 0;
  late AutoCompleteTextField<Medicine> medicineNameTextField;
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
        title: const Text('Add Prescription'),
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
            title: const Text('Prescription Details'),
            content: Column(
              children: [
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(labelText: "Docter's note"),
                ),
                TextFormField(
                  controller: diagnosisController,
                  decoration: const InputDecoration(labelText: 'Diagnosis'),
                ),
                TextFormField(
                  controller: problemController,
                  decoration: const InputDecoration(labelText: 'Problem'),
                ),
                TextFormField(
                  controller: totalAmountController,
                  decoration: const InputDecoration(labelText: 'Total Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: remainingAmountController,
                  decoration:
                      const InputDecoration(labelText: 'Remaining Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: paidAmountController,
                  decoration: const InputDecoration(labelText: 'Paid Amount'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Add Medications'),
            content: Column(
              children: [
                const SizedBox(height: 10),
                if (prescriptionLines.isNotEmpty)
                  const Text('Prescription Lines:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                for (var line in prescriptionLines)
                  ListTile(
                    title: Text(
                        '${line.medicine.name}${line.strength == null ? "" : "-" + line.strength} '),
                    subtitle: Text('${line.doses} | ${line.duration}'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    _showAddMedicationBottomSheet(context);
                  },
                  child: const Text('Add Medications'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddMedicationBottomSheet(BuildContext context) async {
    await Provider.of<MedicineProvider>(context, listen: false)
        .justLoadAllMedicines();
    List<Medicine> medicines =
        await Provider.of<MedicineProvider>(context, listen: false).medicines;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: MedicationForm((formData) {
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
          }, medicines),
        );
      },
    );
  }

  void savePrescriptionData() {
    // Implement logic to save prescription data
    // Access data using controllers: detailsController.text, diagnosisController.text, etc.
    // Also, use the prescriptionLines list to access medication data
  }
}
