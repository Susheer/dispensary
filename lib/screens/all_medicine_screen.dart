// all_patients_screen.dart
import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:dispensary/screens/new_medicine_screen.dart';
import 'package:dispensary/screens/not_found_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/common/patient_details_widget.dart';
import 'package:dispensary/appConfig.dart';

class AllMedicineScreen extends StatefulWidget {
  @override
  State<AllMedicineScreen> createState() => _AllMedicineScreenState();
}

class _AllMedicineScreenState extends State<AllMedicineScreen> {
  int pageSize = AppConfig.PageSize;
  int currentPage = 0;
  bool isLoading = false;
  bool initScreenUponLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final medicineProvider = Provider.of<MedicineProvider>(context);
    medicineProvider.initList();
    currentPage = 1;
  }

  void deleteMe(int id) {
    Provider.of<MedicineProvider>(context, listen: false)
        .deleteMedicineById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicineProvider>(
      builder: (context, medicineProvider, child) {
        List<Medicine> medicines = medicineProvider.medicines;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Medicine List'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${medicines.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  medicineProvider.loadAllMedicines();
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewMedicineScreen(),
                    ),
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
                medicines.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: ((medicines.length + 1) <
                                  medicineProvider.medicineCountInDb)
                              ? medicines.length + 1
                              : medicineProvider
                                  .medicineCountInDb, // Add 1 for loading indicator
                          itemBuilder: (context, index) {
                            if (index == medicines.length) {
                              // Reached the end, load more
                              if (isLoading == false) {
                                _loadMore();
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }

                            Medicine medicine = medicines[index];
                            return ListTile(
                              title: Text(medicine.name),
                              subtitle: Text(medicine.description),
                              trailing: IconButton(
                                tooltip: "Delete",
                                icon: const Icon(
                                    Icons.delete), // Example action icon
                                onPressed: () {
                                  deleteMe(medicine.sysMedicineId);
                                },
                              ),
                              onTap: () {
                                // Handle the entire ListTile click here if needed
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         EditMedicineScreen(medicines[index]),
                                //   ),
                                // );
                                print('ListTile Clicked');
                              },
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text('No medicines found'),
                      )
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
                      tooltip: 'Add Dummy medicines',
                      onPressed: () {
                        Provider.of<MedicineProvider>(context, listen: false)
                            .insertsDummyMedicines();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: "Claer table",
                      onPressed: () {
                        Provider.of<MedicineProvider>(context, listen: false)
                            .deleteAllMedicines();
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
      await Provider.of<MedicineProvider>(context, listen: false)
          .fetchNextPage(currentPage * pageSize, pageSize);
      currentPage++;
      isLoading = false;
    }
  }
}
