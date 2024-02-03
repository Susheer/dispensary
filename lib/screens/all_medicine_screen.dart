// all_patients_screen.dart
import 'package:dispensary/common/edit_medicine_bottom_sheet.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:dispensary/screens/new_medicine_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            title: Text('Available medicine: ${medicines.length}'),
            actions: [
              
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewMedicineScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                icon: const Icon(
                  Icons.post_add,
                  size: 18,
                ), // Icon widget
                label: const Text('Add New'), // Text widget
              ),
             

              // Add more IconButton widgets for additional actions as needed
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: ThemeData().primaryColor,
                  constraints:
                      BoxConstraints(minHeight: 10, minWidth: MediaQuery.of(context).size.width),
                ),
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: "Edit",
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      // Show the bottom sheet when the button is clicked
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) =>
                                            EditMedicineBottomSheet(
                                          initialData: {
                                            'name': medicine.name,
                                            'description': medicine.description
                                          },
                                          onSave: (updatedData) {
                                            Medicine updatedMedicine = Medicine(
                                                sysMedicineId:
                                                    medicine.sysMedicineId,
                                                name: updatedData['name'],
                                                description:
                                                    updatedData['description'],
                                                createdDate:
                                                    medicine.createdDate,
                                                updatedDate: DateTime.now());

                                            medicineProvider.updateMedicineById(
                                                updatedMedicine.sysMedicineId,
                                                updatedMedicine);
                                            print('Updated Data: $updatedData');
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    tooltip: "Delete",
                                    icon: const Icon(
                                        Icons.delete), // Example action icon
                                    onPressed: () {
                                      deleteMe(medicine.sysMedicineId);
                                    },
                                  ),
                                ],
                              ),
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
