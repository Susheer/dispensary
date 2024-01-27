// search_screen.dart
import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/common/typography.dart';
import 'package:dispensary/screens/patient_screen.dart';
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

  bool isSearchBarExpanded = false;
  String selectedGender = 'Select Gender';
  List<Patient> searchResult = [];

  Future<void> onSearch() async {
    String g = "";
    if (selectedGender != "Select Gender") {
      g = Patient.parseGenderToString(Patient.parseGender(selectedGender));
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
  }

  Future<void> onClear() async {
    setState(() {
      mobileController.clear();
      selectedGender = 'Select Gender';
      nameController.clear();
      searchResult = [];
    });
  }

  @override
  void dispose() {
    nameController?.dispose();
    mobileController?.dispose();
    searchResult = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            expandedSearchContainer(context),
            const SizedBox(height: 16.0),
            Expanded(
                child: ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                Patient patient = searchResult[index];
                return SearchedPatient(patient: patient);
              },
            )),
          ],
        ));
  }

  Widget patientGenderWidget() {
    return Row(
      children: [
        const Icon(
          Icons.female,
          size: 29,
        ),
        const SizedBox(
          width: 9,
        ),
        Expanded(
          child: DropdownButton<String>(
            value: selectedGender,
            hint: const Text('Select Gender'),
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });
            },
            items: <String>[
              'Select Gender', // Default option
              'Male',
              'Female',
              'Other',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 65 / 100),
                  child: Row(
                    children: [
                      Text(value), // Text
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ); // Gender Radio Buttons
  }

  Container expandedSearchContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                labelText: 'Patient Name', icon: Icon(Icons.person)),
          ),
          if (isSearchBarExpanded == true)
            TextField(
              controller: mobileController,
              decoration: const InputDecoration(
                  labelText: 'Mobile Number', icon: Icon(Icons.phone_iphone)),
            ),
          const SizedBox(height: 12.0),
          if (isSearchBarExpanded == true) patientGenderWidget(),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 30 / 100, 40)),
                onPressed: onSearch,
                child: const Text('Search'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 30 / 100, 40)),
                onPressed: onClear,
                child: const Text('Clear'),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearchBarExpanded = !isSearchBarExpanded;
                    });
                  },
                  icon: Icon(
                    isSearchBarExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  )),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class SearchedPatient extends StatelessWidget {
  const SearchedPatient({
    super.key,
    required this.patient,
  });

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientScreen(patientId: patient.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 12,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding:
              const EdgeInsets.only(top: 17, bottom: 35, left: 25, right: 25),
          child: Column(
            children: [
              Typography2(label: 'Name', value: patient.name),
              RowWithLabelAndValueSet(
                  label1: 'Gender ',
                  label2: 'Mob ',
                  value1: Patient.parseGenderToString(patient.gender),
                  value2: patient.mobileNumber),
              const Separator(),
              Typography2(
                  label: 'Gurdian Name ', value: patient.guardianName ?? ""),
              Typography2(label: 'Address ', value: patient.address ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
