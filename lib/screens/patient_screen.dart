import 'package:dispensary/common/account_screen.dart';
import 'package:dispensary/common/edit_details_bottom_sheet.dart';
import 'package:dispensary/common/medicine_card.dart';
import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/models/account_model.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/models/medicine.dart';
import 'package:flutter/material.dart';

class PatientScreen extends StatelessWidget {
  final int patientId;
  Account account =
      Account(pendingBalance: 2, totalPaid: 11, totalSinceJoining: 22);
  Guardian guradian = Guardian(
      name: 'Sudheer',
      mobileNumber: '+1893 39993',
      gender: 'Male',
      address: 'Address',
      relation: GuardianRelation.Spouse);
  List<Medicine> medicines = [];
  PatientScreen({required this.patientId}) {
    // One-time setup logic can go here
    medicines = generateDummyMedicines();
  }

  @override
  Widget build(BuildContext context) {
    // Use the patientId to fetch more details from the database
    // Implement a function to fetch patient details by ID in your DatabaseService

    // For now, let's assume we have a Patient object
    Patient patient = fetchPatientById(patientId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // Example action icon
            onPressed: () {
              // Add your logic for the edit action here
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
                  Text('Name: ${patient.name}'),
                  Text('Mobile: ${patient.mobileNumber}'),
                  Text('Gender: ${patient.gender}'),
                  Text('Address: ${patient.address}'),
                  // Add more patient details as needed
                ],
                enableEdit: true,
                onEditPressed: () {
                  print('Edit patient');
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => EditDetailsBottomSheet(
                      patient: patient,
                      guardian: guradian,
                      isEditingPatient: true,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Section 2: Guardian Details
              buildSection(
                title: 'Guardian Details',
                content: [
                  // Add guardian details UI here (e.g., name, mobile, gender radio, address)
                  Text('Guardian Name: ${guradian.name}'),
                  Text('Guardian Mobile: ${guradian.mobileNumber}'),
                  Text('Guardian Gender: ${guradian.gender}'),
                  Text('Guardian Address: ${guradian.address}'),
                ],
                enableEdit: true,
                onEditPressed: () {
                  print('Edit Guardian Details');
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => EditDetailsBottomSheet(
                      patient: patient,
                      guardian: guradian,
                      isEditingPatient: false,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Section 2: Guardian Details
              buildSection(
                  title: 'Last Visit',
                  content: [
                    // Add guardian details UI here (e.g., name, mobile, gender radio, address)
                    const Text('Problem Reported: Fever and Body Ache'),
                    const Text('Dignosis: Viral Fever'),
                    Separator(),
                    const Text(
                      'Medicines',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            14.0, // You can adjust the font size as needed
                      ),
                    ),
                    buildMedicineList("Hello", medicines),
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
                onEditPressed: () {
                  print('Edit Account Details');
                },
              ),
              // Section 4: Action Buttons
              buildSection(
                title: 'Action Buttons',
                content: [
                  buildButton('My Prescription', () {
                    // Add your logic for "My Prescription" button
                  }),
                  buildButton('Add Prescription', () {
                    // Add your logic for "Add Prescription" button
                  }),
                  buildButton('Schedule Follow Up', () {
                    // Add your logic for "Schedule Follow Up" button
                  }),
                  buildButton('Account Details', () {
                    // Add your logic for "Account Details" button
                  }),
                ],
                enableEdit: false,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildActionButton(
                  icon: Icons.local_pharmacy,
                  onPressed: () {
                    // Add your logic for the button's onPressed event
                  },
                  tooltip: 'View My Prescriptions',
                ),
                buildActionButton(
                  icon: Icons.add_box,
                  onPressed: () {
                    // Add your logic for the button's onPressed event
                  },
                  tooltip: 'Add a New Prescription',
                ),
                buildActionButton(
                  icon: Icons.account_balance_wallet,
                  onPressed: () {
                    // Add your logic for the button's onPressed event
                  },
                  tooltip: 'View Account Details',
                ),
                buildActionButton(
                  icon: Icons.event,
                  onPressed: () {
                    // Add your logic for the button's onPressed event
                  },
                  tooltip: 'Schedule Follow Up',
                ),
                // Add more buttons using buildActionButton as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (enableEdit)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEditPressed,
                ),
            ],
          ),
          ...content,
        ],
      ),
    );
  }

  Widget buildSection2(String title, List<Widget> content) {
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
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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

  // Replace this with actual database call to fetch patient details by ID
  Patient fetchPatientById(int patientId) {
    // Simulating fetching details from the database
    return Patient(
      id: patientId,
      name: 'John Doe',
      mobileNumber: '+1234567890',
      gender: 'Male',
      address: '123 Main St',
      allergies: ['Pollen', 'Dust'],
    );
  }
}

// some fake methods
List<Medicine> generateDummyMedicines() {
  return [
    Medicine(
      id: 1,
      name: 'Aspirin',
      dosage: '500mg',
      strength: 'Low',
      description: 'Pain reliever',
      price: 5.99,
    ),
    Medicine(
      id: 2,
      name: 'Amoxicillin',
      dosage: '250mg',
      strength: 'Medium',
      description: 'Antibiotic',
      price: 10.99,
    ),
    Medicine(
      id: 3,
      name: 'Ibuprofen',
      dosage: '200mg',
      strength: 'High',
      description: 'Anti-inflammatory',
      price: 7.49,
    ),
    // Add more dummy medicines as needed
  ];
}
