import 'package:dispensary/common/medicine_card.dart';
import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/models/medicine.dart';
import 'package:flutter/material.dart'; // Import the Patient model

class PatientScreen extends StatelessWidget {
  final int patientId;
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
                'Patient Details',
                [
                  Text('Name: ${patient.name}'),
                  Text('Mobile: ${patient.mobileNumber}'),
                  Text('Gender: ${patient.gender}'),
                  Text('Address: ${patient.address}'),
                  // Add more patient details as needed
                ],
              ),
              const SizedBox(height: 20),

              // Section 2: Guardian Details
              buildSection(
                'Guardian Details',
                [
                  // Add guardian details UI here (e.g., name, mobile, gender radio, address)
                  const Text('Guardian Name: John Doe'),
                  const Text('Guardian Mobile: +9876543210'),
                  const Text('Guardian Gender: Male'),
                  const Text('Guardian Address: 456 Guardian St'),
                ],
              ),
              const SizedBox(height: 20),

              // Section 2: Guardian Details
              buildSection(
                'Last Visit',
                [
                  // Add guardian details UI here (e.g., name, mobile, gender radio, address)
                  const Text('Problem Reported: Fever and Body Ache'),
                  const Text('Dignosis: Viral Fever'),
                  Separator(),
                  const Text(
                    'Medicines',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0, // You can adjust the font size as needed
                    ),
                  ),
                  buildMedicineList("Hello", medicines),
                ],
              ),
              const SizedBox(height: 20),

              // Section 3: Account Details
              buildSection(
                'Account Details',
                [
                  // Add guardian details UI here (e.g., name, mobile, gender radio, address)
                  const Text('Total Since Joining: 1000-/Rs'),
                  const Text('Total Paid: 800-/Rs'),
                  const Text('Pending Bal: 200-/Rs'),
                  const Text('Next Follow Up: 02/10/2024'),
                ],
              ),
              // Section 4: Action Buttons
              buildSection(
                'Action Buttons',
                [
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
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Add your logic for the "Add" action here
                    // For example: navigate to a screen for adding a new patient
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Add your logic for the "Search" action here
                    // For example: navigate to a search screen
                  },
                ),
                // Add more IconButton widgets for additional actions as needed
              ],
            ),
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

  Widget buildSection(String title, List<Widget> content) {
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
