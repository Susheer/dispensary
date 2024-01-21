import 'package:dispensary/common/account_screen.dart';
import 'package:dispensary/common/badge.dart';
import 'package:dispensary/common/edit_details_bottom_sheet.dart';
import 'package:dispensary/common/medicine_card.dart';
import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/models/account_model.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/providers/prescription_provider.dart';
import 'package:dispensary/screens/add_prescription_screen.dart';
import 'package:dispensary/screens/prescription_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  final int patientId;
  List<Medicine> medicines = [];

  PatientScreen({required this.patientId}) {
    medicines = generateDummyMedicines();
  }
  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  Patient? patient;
  Account account =
      Account(pendingBalance: 2, totalPaid: 11, totalSinceJoining: 22);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<PatientProvider>(context)
        .fetchPatientById(widget.patientId)
        .then((value) {
      if (value != null) {
        setState(() {
          patient = value;
        });
      }
    });
  }

  Function()? addPrescriptionListener() {
    if (patient != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPrescriptionScreen(patient: patient!),
        ),
      );
    }
  }

  Function()? viewPrescriptionListener() {
    if (widget.patientId != null) {
      if (patient != null && patient?.id != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PrescriptionScreen(patientId: patient!.id, patient: patient!),
          ),
        );
      }
    }
  }

  Function()? scheduleFollowUpListener() {}

  Function()? updateAccountListener() {}

  void onPatientUpdate(Patient response) async {
    if (patient != null) {
      bool isUpdated =
          await Provider.of<PatientProvider>(context, listen: false)
              .updatePatientByPatientId(response);
      if (isUpdated == true) {
        updateScreen(response.id);
      }
    }
  }

  void updateScreen(int patientId) {
    Provider.of<PatientProvider>(context, listen: false)
        .fetchPatientById(patientId)
        .then((value) {
      if (value != null) {
        setState(() {
          Provider.of<PatientProvider>(context, listen: false)
              .updatePatientInList(value);
          patient = value;
        });
      }
    });
  }

  void onGuardianUpdate(Patient response) async {
    if (patient != null) {
      bool isUpdated =
          await Provider.of<PatientProvider>(context, listen: false)
              .updateGuardianByPatientId(response);
      if (isUpdated == true) {
        updateScreen(response.id);
      }
    }
  }

  void deleteMe(int id) {
    Provider.of<PatientProvider>(context, listen: false).deleteMe(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [
          IconButton(
            tooltip: "Delete forever",
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              deleteMe(widget.patientId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Patient Details
              buildSection(
                title: 'Patient Details',
                content: [
                  Text('Name: ${patient?.name}'),
                  Text('Mobile: ${patient?.mobileNumber}'),
                  Text('Gender: ${patient?.gender}'),
                  Text('Address: ${patient?.address}'),
                  const Separator(),
                  const Text(
                    'Allergies',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0, // You can adjust the font size as needed
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BadgeContainer(
                    badges: patient?.allergies ?? [],
                  )
                ],
                enableEdit: true,
                onEditPressed: () {
                  if (patient != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: EditDetailsBottomSheet(
                          patient: patient!,
                          isEditingPatient: true,
                          onSavePressed: onPatientUpdate,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              buildSection(
                title: 'Guardian Details',
                content: [
                  Text('Name: ${patient?.guardianName}'),
                  Text('Mobile: ${patient?.guardianMobileNumber}'),
                  Text('Gender: ${patient?.guardianGender}'),
                  Text('Address: ${patient?.guardianAddress}'),
                ],
                enableEdit: true,
                onEditPressed: () {
                  if (patient != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: EditDetailsBottomSheet(
                          patient: patient!,
                          isEditingPatient: false,
                          onSavePressed: onGuardianUpdate,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              buildSection(
                  title: 'Last Visit',
                  content: [
                    // Add guardian details UI here (e.g., name, mobile, gender radio, address)
                    const Text('Chief Complaint: Fever and Body Ache'),
                    const Text('Dignosis: Viral Fever'),
                  ],
                  enableEdit: false),
              const SizedBox(height: 20),

              // Section 3: Account Details
              buildSection(
                title: 'Account Details',
                content: [
                  AccountScreen(account: account),
                  const Text('Next Follow Up: 02/10/2024'),
                ],
                enableEdit: true,
                onEditPressed: () {},
              ),
              const Separator(),
              buildActionButtonsRow(context),
              // Section 4: Action Buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMedicineList(String title, List<Medicine> medicines) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: medicines.map((medicine) {
          return MedicineCard(medicine: medicine);
        }).toList(),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<Widget> content,
    bool enableEdit = false,
    VoidCallback? onEditPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (enableEdit)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEditPressed,
                ),
            ],
          ),
          ...content,
        ],
      ),
    );
  }

  Widget buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Future<List<Prescription>> getMyPrescriptions(int pId) async {
    List<Prescription> pList =
        await Provider.of<PrescriptionProvider>(context, listen: false)
            .getPrescriptionsByPatientIdWithDetails(pId);
    return pList;
  }

  Widget buildActionButtonsRow(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, maxHeight: 40),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
          icon: const Icon(Icons.add_box),
          tooltip: "Add Prescription",
          onPressed: addPrescriptionListener,
        ),
        IconButton(
          icon: const Icon(Icons.view_agenda),
          tooltip: "My Prescription",
          onPressed: viewPrescriptionListener,
        ),
        IconButton(
          icon: const Icon(Icons.schedule),
          tooltip: "Schedule Follow Up",
          onPressed: scheduleFollowUpListener,
        ),
        IconButton(
          icon: const Icon(Icons.account_balance_wallet),
          tooltip: "Account",
          onPressed: updateAccountListener,
        ),
      ]),
    );
  }
}

// some fake methods
List<Medicine> generateDummyMedicines() {
  return [
    Medicine(
        sysMedicineId: 1,
        name: 'Aspirin',
        description: 'Pain reliever',
        createdDate: DateTime.timestamp(),
        updatedDate: DateTime.timestamp()),
    Medicine(
        sysMedicineId: 2,
        name: 'Amoxicillin',
        description: 'Antibiotic',
        createdDate: DateTime.timestamp(),
        updatedDate: DateTime.timestamp()),
    Medicine(
        sysMedicineId: 3,
        name: 'Ibuprofen',
        description: 'Anti-inflammatory',
        createdDate: DateTime.timestamp(),
        updatedDate: DateTime.timestamp()),
  ];
}
