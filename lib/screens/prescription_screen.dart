import 'package:dispensary/common/prescriptions/prescription_widget.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/providers/prescription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrescriptionScreen extends StatefulWidget {
  final int patientId;
  final Patient patient;
  const PrescriptionScreen({Key? key, required this.patientId, required this.patient}) : super(key: key);

  @override
  PrescriptionScreenState createState() => PrescriptionScreenState();
}

class PrescriptionScreenState extends State<PrescriptionScreen> {
  late PrescriptionProvider _prescriptionProvider;
  int currentPage = 0;
  bool isLoadingNextPage = false;
  bool initScreenUponLoad = false;

  @override
  void dispose() {
    super.dispose();
    isLoadingNextPage = false;
    initScreenUponLoad = false;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (initScreenUponLoad == false) {
      initScreenUponLoad = true;
      _prescriptionProvider = Provider.of<PrescriptionProvider>(context);
      await _prescriptionProvider.countPrescriptionsByPatientId(widget.patientId);
      await _prescriptionProvider.initPrescriptionList(widget.patientId);
    }
  }

  int getItemCount(int snapshotLength, int totalAvailableCount) {
    if ((snapshotLength + 1) < totalAvailableCount) {
      return snapshotLength + 1;
    }
    return totalAvailableCount; // reached to the end of list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescriptions'), actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${_prescriptionProvider.getPrescriptionList.length}/${_prescriptionProvider.dbCount}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]),
      body: Column(
        children: [
          Expanded(
            child: Consumer<PrescriptionProvider>(
              builder: (context, prescriptionProvider, child) {
                List<Prescription> prescriptions = prescriptionProvider.getPrescriptionList;
                if (prescriptions.isNotEmpty) {
                  debugPrint("prescriptions.length ${prescriptions.length}");
                  int itemCount = getItemCount(prescriptions.length, prescriptionProvider.dbCount);
                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == prescriptions.length) {
                        // All data was available in 'prescriptions' has been displayed.
                        //Now load new data if data are there in db.
                        debugPrint('-----reached at end-----');
                        if (index < prescriptionProvider.dbCount) {
                          debugPrint('-index: $index < prescriptionsCount: ${prescriptionProvider.dbCount} = true-------');
                          // stop incrementing calling loadOtherPage untill current req is completed.
                          if (isLoadingNextPage == false) {
                            debugPrint('Before calling loadMore');
                            // now stop calling next page
                            isLoadingNextPage = true;
                            currentPage = currentPage + 1;
                            int nextPage = currentPage;
                            loadOtherPage(nextPage);
                            debugPrint('After calling loadMore');
                          }
                        }
                      }
                      if (isLoadingNextPage == true) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (index < prescriptions.length) {
                        return PrescriptionWidget(
                          patientName: widget.patient.name,
                          sysPrescriptionId: prescriptions[index].sysPrescriptionId,
                          patientId: prescriptions[index].patientId,
                          diagnosis: prescriptions[index].diagnosis,
                          chiefComplaint: prescriptions[index].chiefComplaint,
                          createdDate: prescriptions[index].createdDate,
                          updatedDate: prescriptions[index].updatedDate,
                          totalAmount: prescriptions[index].totalAmount,
                          paidAmount: prescriptions[index].paidAmount,
                          lines: prescriptions[index].prescriptionLines,
                        );
                      } else {
                        return const Center(
                          child: Text("Ohh, Is there any more data? Refreash it"),
                        );
                      }
                    },
                  );
                }
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notes,
                      size: 50,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("No Prescription found"),
                  ],
                ));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your button click logic here
                setState(() {});
              },
              child: const Text('Refresh'),
            ),
            ElevatedButton(
              onPressed: () {
                _prescriptionProvider.addFakePrescriptions(widget.patientId);
              },
              child: const Text('Add Fake Prescription'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadOtherPage(nextPage) async {
    debugPrint('loadOtherPage invoked');
    debugPrint('loading page:- ${nextPage}');
    await await Future.delayed(const Duration(seconds: 1));
    await _prescriptionProvider.loadNextPage(widget.patientId, nextPage);
    isLoadingNextPage = false;
    debugPrint('loading page: completed');
  }
}
