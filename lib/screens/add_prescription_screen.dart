import 'package:dispensary/common/medication_form.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<FormState> _formPrescriptionDetails = GlobalKey<FormState>();
  final GlobalKey<FormState> _formMedications = GlobalKey<FormState>();
  List<PrescriptionLine> prescriptionLines = [];
  double? totalAmount;
  double? paidAmount;
  String? onValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Can not left blank';
    }
    return null;
  }

  void displayMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Prescription'),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              if (_formPrescriptionDetails.currentState!.validate()) {
                setState(() {
                  _currentStep += 1;
                });
              } else {
                displayMessage("Complete medication details");
              }
            } else {
              // Save prescription data and navigate away (you can replace this logic)
              Prescription prescription = Prescription(
                  sysPrescriptionId: 1, // temp id
                  prescriptionLines: prescriptionLines,
                  patientId: widget.patient.id,
                  details: detailsController.text,
                  diagnosis: diagnosisController.text,
                  problem: problemController.text,
                  createdDate: DateTime.now(),
                  updatedDate: DateTime.now(),
                  totalAmount: totalAmount ?? 0.0,
                  paidAmount: paidAmount ?? 0.0);
              savePrescriptionData(prescription.toMap());
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
              content: Form(
                key: _formPrescriptionDetails,
                child: Column(
                  children: [
                    TextFormField(
                      controller: detailsController,
                      validator: onValidate,
                      decoration:
                          const InputDecoration(labelText: "Docter's note"),
                    ),
                    TextFormField(
                      controller: diagnosisController,
                      validator: onValidate,
                      decoration: const InputDecoration(labelText: 'Diagnosis'),
                    ),
                    TextFormField(
                      controller: problemController,
                      validator: onValidate,
                      decoration: const InputDecoration(labelText: 'Problem'),
                    ),
                    TextFormField(
                      controller: totalAmountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: onValidate,
                      decoration:
                          const InputDecoration(labelText: 'Total Amount'),
                      onChanged: (value) {
                        setState(() {
                          try {
                            totalAmount = double.parse(value);
                          } catch (e) {
                            totalAmount = null;
                          }
                        });
                      },
                    ),
                    TextFormField(
                      enabled: false,
                      controller: remainingAmountController,
                      validator: onValidate,
                      decoration:
                          const InputDecoration(labelText: 'Remaining Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: paidAmountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      validator: onValidate,
                      decoration:
                          const InputDecoration(labelText: 'Paid Amount'),
                      onChanged: (value) {
                        setState(() {
                          try {
                            paidAmount = double.parse(value);
                            double amt =
                                (totalAmount ?? 0.0) - (paidAmount ?? 0.0);
                            remainingAmountController.text = amt.toString();
                          } catch (e) {
                            paidAmount = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: const Text('Add Medications'),
              content: Form(
                key: _formMedications,
                child: Column(
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
            ),
          ],
        ),
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
          child: MedicationForm(addPrescriptionLine, medicines),
        );
      },
    );
  }

  void savePrescriptionData(Map<String, dynamic> prescriptionForm) {
    // save data to db;
  }

  void addPrescriptionLine(Map<String, dynamic> medicationFormData) {
    Medicine medicine = Medicine(
      sysMedicineId: medicationFormData[
          'sysMedicineId'], // Replace with actual medicine ID
      name: medicationFormData['medicineName'],
      description: medicationFormData['description'],
      createdDate: DateTime.now(), // remove while saveing to db
      updatedDate: DateTime.now(), // remove while saveing to db
    );

    PrescriptionLine aLine = PrescriptionLine(
      sysPrescriptionLineId: prescriptionLines.length + 1,
      medicine: medicine,
      doses: medicationFormData['doses'],
      duration: medicationFormData['duration'],
      notes: medicationFormData['notes'],
      strength: medicationFormData['strength'],
    );
    setState(() {
      prescriptionLines.add(
          aLine); // add to line list, as one prescription may have severline lines.
    });
    Navigator.pop(context);
  }
}
