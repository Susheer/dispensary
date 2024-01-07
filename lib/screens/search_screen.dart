// search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/models/patient.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  // Add a ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Patients'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Invoke search function from the PatientProvider
                    Provider.of<PatientProvider>(context, listen: false)
                        .searchPatients(
                      name: nameController.text,
                      mobileNumber: mobileController.text,
                      gender: genderController.text,
                    );

                    // Scroll to the top of the list
                    _scrollController.animateTo(
                      0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text('Search'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Clear the search criteria and results
                    nameController.clear();
                    mobileController.clear();
                    genderController.clear();
                    Provider.of<PatientProvider>(context, listen: false)
                        .clearSearchResults();
                  },
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Build the ListView only if there are search results
            Consumer<PatientProvider>(
              builder: (context, patientProvider, child) {
                if (patientProvider.searchResults.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: patientProvider.searchResults.length,
                      itemBuilder: (context, index) {
                        Patient patient = patientProvider.searchResults[index];
                        return ListTile(
                          title: Text(patient.name),
                          subtitle: Text(
                              'Mobile: ${patient.mobileNumber}, Gender: ${patient.gender}'),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No search results.'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the ScrollController
    _scrollController.dispose();
    super.dispose();
  }
}
