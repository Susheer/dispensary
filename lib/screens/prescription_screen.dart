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
  int pageSize = AppConfig.PrescriptionSize;
  int currentPage = 0;
  bool isLoading = false;
  bool initScreenUponLoad = false;
  List<Prescription> presscriptionList = [];
  late int prescriptionsCount;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print("PrescriptionScreenState didChangeDependencies Invoked");
    if (initScreenUponLoad == false) {
      //initScreenUponLoad = true;
      _prescriptionProvider =
          Provider.of<PrescriptionProvider>(context, listen: false);
      prescriptionsCount = await _prescriptionProvider
          .countPrescriptionsByPatientId(widget.patientId);
      List<Prescription> list = await _prescriptionProvider
          .getPrescriptionsByPatientIdWithDetails(widget.patientId);
      _prescriptionProvider.prescriptionController.add(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Patient Details Section',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Prescription>>(
              stream: _prescriptionProvider.prescriptionsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Prescription> prescriptions = snapshot.data!;
                  return ListView.builder(
                    itemCount: prescriptions.length,
                    itemBuilder: (context, index) {
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
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
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
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
