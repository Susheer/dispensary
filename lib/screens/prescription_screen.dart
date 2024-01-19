import 'package:dispensary/appConfig.dart';
import 'package:dispensary/common/prescriptions/prescription_widget.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/providers/prescription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrescriptionScreen extends StatefulWidget {
  final int patientId;
  PrescriptionScreen({required this.patientId});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
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
    print("PrescriptionScreenState didChangeDependencies Invoked");
    if (initScreenUponLoad == false) {
      initScreenUponLoad = true;
      _prescriptionProvider = Provider.of<PrescriptionProvider>(context);
      await _prescriptionProvider
          .countPrescriptionsByPatientId(widget.patientId);
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
                List<Prescription> prescriptions =
                    prescriptionProvider.getPrescriptionList;
                if (prescriptions.isNotEmpty) {
                  debugPrint("prescriptions.length ${prescriptions.length}");
                  int itemCount = getItemCount(
                      prescriptions.length, prescriptionProvider.dbCount);
                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == prescriptions.length) {
                        // All data was available in 'prescriptions' has been displayed.
                        //Now load new data if data are there in db.
                        debugPrint('-----reached at end-----');
                        if (index < prescriptionProvider.dbCount) {
                          debugPrint(
                              '-index: $index < prescriptionsCount: ${prescriptionProvider.dbCount} = true-------');
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
                          sysPrescriptionId:
                              prescriptions[index].sysPrescriptionId,
                          patientId: prescriptions[index].patientId,
                          details: prescriptions[index].details,
                          diagnosis: prescriptions[index].diagnosis,
                          problem: prescriptions[index].problem,
                          createdDate: prescriptions[index].createdDate,
                          updatedDate: prescriptions[index].updatedDate,
                          totalAmount: prescriptions[index].totalAmount,
                          paidAmount: prescriptions[index].paidAmount,
                          lines: prescriptions[index].prescriptionLines,
                        );
                      } else {
                        return const Center(
                          child:
                              Text("Ohh, Is there any more data? Refreash it"),
                        );
                      }
                    },
                  );
                }
                return const Text("No Prescription found");
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                _prescriptionProvider.addFakePrescriptions(widget.patientId);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadOtherPage(nextPage) async {
    debugPrint('loadOtherPage invoked');
    debugPrint('loading page:- ${nextPage}');
    await await Future.delayed(const Duration(seconds: 5));
    await _prescriptionProvider.loadNextPage(widget.patientId, nextPage);
    isLoadingNextPage = false;
    debugPrint('loading page: completed');
  }
}
