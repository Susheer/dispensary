import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:faker/faker.dart';

List<Prescription> generateUniquePrescriptions() {
  List<Prescription> prescriptions = [];

  for (int i = 1; i <= 10; i++) {
    List<PrescriptionLine> prescriptionLines = [];

    for (int j = 1; j <= 3; j++) {
      // Assuming you have a function to generate random Medicine data
      Medicine medicine = generateRandomMedicine();

      PrescriptionLine prescriptionLine = PrescriptionLine(
        sysPrescriptionLineId: j,
        medicine: medicine,
        doses: '1',
        duration: '7 days',
        notes: 'Take with meals',
        strength: '500mg',
      );

      prescriptionLines.add(prescriptionLine);
    }

    Prescription prescription = Prescription(
      sysPrescriptionId: i,
      prescriptionLines: prescriptionLines,
      patientId: 123, // Replace with a valid patient ID
      diagnosis: 'Fever',
      chiefComplaint: 'Headache',
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      totalAmount: 50.0,
      paidAmount: 25.0,
    );

    prescriptions.add(prescription);
  }

  return prescriptions;
}

// Example function to generate random Medicine data (replace with your logic)
Medicine generateRandomMedicine() {
  final faker = Faker();
  return Medicine(
    sysMedicineId: faker.randomGenerator.integer(9999),
    name: faker.lorem.word(),
    description: faker.lorem.sentence(),
    createdDate: DateTime.now(),
    updatedDate: DateTime.now(),
  );
}
