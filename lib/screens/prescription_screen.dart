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
  State<PrescriptionScreen> createState() => PrescriptionScreenState();
}

class PrescriptionScreenState extends State<PrescriptionScreen> {
  late PrescriptionProvider _prescriptionProvider;
  final ScrollController _scrollController = ScrollController();
  List<Prescription> _items = [];
  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Safe to use after first build phase
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _prescriptionProvider = Provider.of<PrescriptionProvider>(context, listen: false);
      await _prescriptionProvider.inItPrescriptionScreen(widget.patientId);
      _fetchMore(widget.patientId, _page);
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading) {
          _fetchMore(widget.patientId, _page);
        }
      });
    });
  }

  Future<void> _fetchMore(int patientId, int page) async {
    setState(() => _isLoading = true); // Simulate API delay
    final newItems = await _prescriptionProvider.loadNextPage(patientId, page);
    setState(() {
      _items.addAll(newItems);
      _page++;
      _isLoading = false;
    });
  }

  Future<void> _reloadList(int patientId) async {
    setState(() => _isLoading = true); // Simulate API delay
    final newItems = await _prescriptionProvider.loadNextPage(patientId, 0);
    setState(() {
      _items = []; // blank
      _items.addAll(newItems);
      _page = 1;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget noPrescription() {
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
  }

  Widget _buildPrescriptionItem(BuildContext context, int index) {
    if (index == _items.length) {
      return _isLoading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          : const SizedBox();
    }
    return PrescriptionWidget(
      patientName: widget.patient.name,
      sysPrescriptionId: _items[index].sysPrescriptionId,
      patientId: _items[index].patientId,
      diagnosis: _items[index].diagnosis,
      chiefComplaint: _items[index].chiefComplaint,
      createdDate: _items[index].createdDate,
      updatedDate: _items[index].updatedDate,
      totalAmount: _items[index].totalAmount,
      paidAmount: _items[index].paidAmount,
      lines: _items[index].prescriptionLines,
    );
  }

  BottomAppBar bottomAppbar() {
    return BottomAppBar(
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
              Provider.of<PrescriptionProvider>(context, listen: false).addFakePrescriptions(widget.patientId).then((res) {
                _reloadList(widget.patientId);
              });
            },
            child: const Text('Add Mock Prescription'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final pList = context.watch<PrescriptionProvider>().getPrescriptionList;
    return Scaffold(
        appBar: AppBar(title: const Text('Prescriptions'), actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (_items.length).toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
        body: _items.isEmpty
            ? noPrescription()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(controller: _scrollController, itemCount: _items.length + 1, itemBuilder: _buildPrescriptionItem),
                  )
                ],
              ),
        bottomNavigationBar: bottomAppbar());
  }
}
