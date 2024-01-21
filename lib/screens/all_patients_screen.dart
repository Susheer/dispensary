// all_patients_screen.dart
import 'package:dispensary/screens/not_found_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/common/patient_details_widget.dart';
import 'package:dispensary/appConfig.dart';

class AllPatientsScreen extends StatefulWidget {
  @override
  State<AllPatientsScreen> createState() => _AllPatientsScreenState();
}

class _AllPatientsScreenState extends State<AllPatientsScreen> {
  int pageSize = AppConfig.PageSize;
  int currentPage = 0;
  bool isLoading = false;
  bool initScreenUponLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initScreenUponLoad == false) {
      initScreenUponLoad = true;
      final patientProvider = Provider.of<PatientProvider>(context);
      patientProvider.initializePatients();
      currentPage++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, patientProvider, child) {
        List<Patient> patients = patientProvider.patients;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient List'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${patients.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllPatientsScreen()),
                  );
                },
              ),
              // Add more IconButton widgets for additional actions as needed
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Display the number of records

                // Display the list of patients
                patients.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: ((patients.length + 1) <
                                  patientProvider.patientsCount)
                              ? patients.length + 1
                              : patientProvider
                                  .patientsCount, // Add 1 for loading indicator
                          itemBuilder: (context, index) {
                            if (index == patients.length) {
                              // Reached the end, load more
                              if (isLoading == false) {
                                _loadMore();
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                            if (index < patients.length) {
                              Patient patient = patients[index];

                              return PatientDetailsWidget(patient: patient);
                            } else {
                              return const Text('Ohh, Please refresh list');
                            }
                          },
                        ),
                      )
                    : NotFoundMessage(message: "No patients available")
              ],
            ),
          ),
          // Responsive card with action buttons
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
                      icon: const Icon(Icons.person_add),
                      tooltip: 'Add Bulk Patient',
                      onPressed: () {
                        Provider.of<PatientProvider>(context, listen: false)
                            .registerDummyPatient();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: "Claer table",
                      onPressed: () {
                        Provider.of<PatientProvider>(context, listen: false)
                            .deleteAllPatients();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadMore() async {
    if (isLoading != true) {
      isLoading = true;
      await Provider.of<PatientProvider>(context, listen: false)
          .fetchNextPage(currentPage * pageSize, pageSize);
      currentPage++;
      isLoading = false;
    }
  }
}
