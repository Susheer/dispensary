// // prescription_editor.dart

// import 'package:dispensary/services/prescription_model_test.dart';
// import 'package:flutter/material.dart';
// import 'package:dispensary/models/prescription_model.dart';
// import 'package:dispensary/models/medicine_model.dart';
// import 'package:dispensary/common/medicine_dialog.dart';

// class PrescriptionEditor extends StatefulWidget {
//   @override
//   _PrescriptionEditorState createState() => _PrescriptionEditorState();
// }

// class _PrescriptionEditorState extends State<PrescriptionEditor> {
//   final GlobalKey<FormState> _prescriptionFormKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _medicineFormKey = GlobalKey<FormState>();

//   List<Prescription> prescriptions = generateUniquePrescriptions();

//   List<Medicine> medicines = [];

//   void addMedicine() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return MedicineDialog(
//           formKey: _medicineFormKey,
//           onAddMedicine: (Medicine medicine) {
//             setState(() {
//               medicines.add(medicine);
//             });
//             Navigator.pop(context);
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Prescription Editor'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _prescriptionFormKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Prescription details
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Short Description'),
//                 onChanged: (value) {
//                   setState(() {
//                     prescriptions[0].shortDescription = value;
//                   });
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Long Description'),
//                 onChanged: (value) {
//                   setState(() {
//                     prescription.longDescription = value;
//                   });
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Short Problem'),
//                 onChanged: (value) {
//                   setState(() {
//                     prescription.shortProblem = value;
//                   });
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Long Problem'),
//                 onChanged: (value) {
//                   setState(() {
//                     prescription.longProblem = value;
//                   });
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Short Diagnosis'),
//                 onChanged: (value) {
//                   setState(() {
//                     prescription.shortDiagnosis = value;
//                   });
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Long Diagnosis'),
//                 onChanged: (value) {
//                   setState(() {
//                     prescription.longDiagnosis = value;
//                   });
//                 },
//               ),

//               // Add medication button
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: addMedicine,
//                 child: Text('Add Medication'),
//               ),

//               // Display added medicines
//               SizedBox(height: 20.0),
//               Text(
//                 'Added Medicines',
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//               if (medicines.isNotEmpty)
//                 Column(
//                   children: medicines.map((medicine) {
//                     return Card(
//                       margin: EdgeInsets.symmetric(vertical: 8.0),
//                       child: ListTile(
//                         title: Text(medicine.name),
//                         subtitle: Text(
//                             'Doses: ${medicine.doses}, Strength: ${medicine.strength}'),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
