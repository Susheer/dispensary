// search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/models/patient.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController genderController = TextEditingController();

  List<Patient> searchResult = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: mobileController,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width - 40, 40)),
              onPressed: () async {
                String g = "";
                if (genderController.text != null &&
                    genderController.text != "") {
                  g = Patient.parseGenderToString(
                      Patient.parseGender(genderController.text));
                }
                Provider.of<PatientProvider>(context, listen: false)
                    .searchPatients(
                  name: nameController.text,
                  mobileNumber: mobileController.text,
                  gender: g,
                )
                    .then((result) {
                  setState(() {
                    searchResult = result;
                  });
                });
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
                child: ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                Patient patient = searchResult[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text(
                      'Mobile: ${patient.mobileNumber}, Gender: ${patient.gender}'),
                );
              },
            )),
          ],
        ));
  }
}
