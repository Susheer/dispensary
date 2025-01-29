import 'package:dispensary/common/account_screen.dart';
import 'package:dispensary/common/badge.dart';
import 'package:dispensary/common/edit_details_bottom_sheet.dart';
import 'package:dispensary/common/medicine_card.dart';
import 'package:dispensary/common/prescriptions/prescription_widget.dart';
import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/common/typography.dart';
import 'package:dispensary/models/account_model.dart';
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/providers/prescription_provider.dart';
import 'package:dispensary/screens/add_prescription_screen.dart';
import 'package:dispensary/screens/prescription_screen.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  final int patientId;

  PatientScreen({required this.patientId});
  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  Patient? patient;
  Prescription? prescription;
  Account? account;
  int _selectedIndex = 0;
  @override
  void didChangeDependencies() {
    debugPrint("didChangeDependencies invoked");
    Provider.of<PatientProvider>(context)
        .fetchPatientById(widget.patientId)
        .then((value) {
      if (value != null) {
        setState(() {
          patient = value;
        });
      }
    });

    Provider.of<PatientProvider>(context)
        .getAccount(widget.patientId)
        .then((accountObj) {
      if (accountObj != null) {
        setState(() {
          account = accountObj;
        });
      }
    });

    Provider.of<PrescriptionProvider>(context)
        .getPrescriptionsByPatientIdWithDetails(widget.patientId,
            pageNum: 0, pageSize: 1)
        .then((prescriptionObj) {
      if (prescriptionObj.isNotEmpty && prescriptionObj[0] != null) {
        setState(() {
          prescription = prescriptionObj[0]!;
        });
      }
    });
    super.didChangeDependencies();
  }

  void updateNextVisit(DateTime newDate) async {
    await Provider.of<PatientProvider>(context, listen: false)
        .updateScheduledDate(widget.patientId, newDate.toIso8601String());

    Provider.of<PatientProvider>(context, listen: false)
        .fetchPatientById(widget.patientId)
        .then((value) {
      if (value != null) {
        setState(() {
          patient = value;
        });
      }
    });

    Provider.of<PatientProvider>(context, listen: false)
        .getAccount(widget.patientId)
        .then((accountObj) {
      if (accountObj != null) {
        setState(() {
          account = accountObj;
        });
      }
    });

    Provider.of<PrescriptionProvider>(context, listen: false)
        .getPrescriptionsByPatientIdWithDetails(widget.patientId,
            pageNum: 0, pageSize: 1)
        .then((prescriptionObj) {
      if (prescriptionObj.isNotEmpty && prescriptionObj[0] != null) {
        setState(() {
          prescription = prescriptionObj[0]!;
        });
      }
    });
  }

  Function()? addPrescriptionListener() {
    if (patient != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPrescriptionScreen(patient: patient!),
        ),
      );
    }
  }

  Function()? viewPrescriptionListener() {
    if (widget.patientId != null) {
      if (patient != null && patient?.id != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PrescriptionScreen(patientId: patient!.id, patient: patient!),
          ),
        );
      }
    }
  }

  void onPatientUpdate(Patient response) async {
    if (patient != null) {
      bool isUpdated =
          await Provider.of<PatientProvider>(context, listen: false)
              .updatePatientByPatientId(response);
      if (isUpdated == true) {
        updateScreen(response.id);
      }
    }
  }

  void updateScreen(int patientId) {
    Provider.of<PatientProvider>(context, listen: false)
        .fetchPatientById(patientId)
        .then((value) {
      if (value != null) {
        setState(() {
          Provider.of<PatientProvider>(context, listen: false)
              .updatePatientInList(value);
          patient = value;
        });
      }
    });
  }

  void onGuardianUpdate(Patient response) async {
    if (patient != null) {
      bool isUpdated =
          await Provider.of<PatientProvider>(context, listen: false)
              .updateGuardianByPatientId(response);
      if (isUpdated == true) {
        updateScreen(response.id);
      }
    }
  }

  void deleteMe(int id) {
    Provider.of<PatientProvider>(context, listen: false).deleteMe(id);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build invoked, patient screen");
    String scheduledDate = "";
    if (patient?.scheduledDate != null) {
      scheduledDate = DateFormat('dd/MM/yyyy').format(patient!.scheduledDate!);
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [
          IconButton(
            tooltip: "Delete forever",
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteMe(widget.patientId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Patient Details
              buildSection(
                title: 'Patient Details',
                content: [
                  Text('Name: ${patient?.name}'),
                  Text('Mobile: ${patient?.mobileNumber}'),
                  if (patient?.gender != null)
                    Text(
                        'Gender: ${Patient.parseGenderToString(patient!.gender)}'),
                  Text('Address: ${patient?.address}'),
                  const Separator(),
                  const Text(
                    'Allergies',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0, // You can adjust the font size as needed
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BadgeContainer(
                    badges: patient?.allergies ?? [],
                  )
                ],
                enableEdit: true,
                onEditPressed: () {
                  if (patient != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: EditDetailsBottomSheet(
                          patient: patient!,
                          isEditingPatient: true,
                          onSavePressed: onPatientUpdate,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              buildSection(
                title: 'Guardian Details',
                content: [
                  Text('Name: ${patient?.guardianName}'),
                  Text('Mobile: ${patient?.guardianMobileNumber}'),
                  if (patient?.guardianGender != null)
                    Text(
                        'Gender: ${Patient.parseGenderToString(patient!.guardianGender!)}'),
                  if (patient?.guardianGender == null) const Text('Gender:'),
                  Text('Address: ${patient?.guardianAddress}'),
                ],
                enableEdit: true,
                onEditPressed: () {
                  if (patient != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: EditDetailsBottomSheet(
                          patient: patient!,
                          isEditingPatient: false,
                          onSavePressed: onGuardianUpdate,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              if (prescription != null)
                buildSection(
                    title: 'Recent Prescription',
                    isLinkButton: true,
                    linkButton: TextButton(
                      onPressed: () {
                        viewPrescriptionListener();
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          // Customize text color
                          fontSize: 14, // Customize font size
                        ),
                      ),
                    ),
                    content: [
                      PrescriptionWidget(
                          sysPrescriptionId: prescription!.sysPrescriptionId,
                          patientId: prescription!.patientId,
                          diagnosis: prescription!.diagnosis,
                          chiefComplaint: prescription!.chiefComplaint,
                          patientName: patient!.name,
                          createdDate: prescription!.createdDate,
                          updatedDate: prescription!.updatedDate,
                          totalAmount: prescription!.totalAmount,
                          paidAmount: prescription!.paidAmount,
                          lines: prescription!.prescriptionLines)
                    ],
                    enableEdit: false),
              const SizedBox(height: 20),

              // Section 3: Account Details
              if (account != null)
                buildSection(
                  title: 'Payments',
                  content: [
                    AccountScreen(account: account!),
                  ],
                  enableEdit: false,
                  onEditPressed: () {},
                ),
              const SizedBox(
                height: 20,
              ),
              buildSection(
                title: 'Visit Timelines',
                content: [
                  const SizedBox(
                    height: 10,
                  ),
                  if (patient != null && patient!.createdDate != null)
                    RowWithLabelAndValueSet(
                        label1: 'First Visit',
                        value1: DateFormat('dd/MM/yyyy')
                            .format(patient!.createdDate!),
                        label2: '- ',
                        value2: timeago.format(patient!.createdDate!)),
                  if (patient != null && patient!.updatedDate != null)
                    RowWithLabelAndValueSet(
                        label1: 'Last Visit',
                        value1: DateFormat('dd/MM/yyyy')
                            .format(patient!.updatedDate!),
                        label2: '- ',
                        value2: timeago.format(patient!.updatedDate!)),
                  Typography1(
                    label: 'Next Visit',
                    value: scheduledDate,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                enableEdit: false,
                onEditPressed: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        fixedColor: Colors.black,
        onTap: (val) async {
          if (val == 0) {
            addPrescriptionListener();
          }
          if (val == 1) {
            viewPrescriptionListener();
          }
          if (val == 2) {
            await showDatePicker(
              context: context,
              initialDate: patient?.scheduledDate ?? DateTime.now(),
              firstDate: patient?.scheduledDate ?? DateTime.now(),
              lastDate: DateTime(2101),
            ).then((selected) {
              if (selected != null) {
                updateNextVisit(selected);
              }
            });
          }
          setState(() {
            _selectedIndex = val;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Prescribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Follow-Up',
          ),
        ],
      ),
    );
  }

  Widget buildMedicineList(String title, List<Medicine> medicines) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: medicines.map((medicine) {
          return MedicineCard(medicine: medicine);
        }).toList(),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<Widget> content,
    bool enableEdit = false,
    bool isLinkButton = false,
    Widget? linkButton = null,
    VoidCallback? onEditPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (enableEdit)
                IconButton(
                  icon: const Icon(Icons.edit_note),
                  iconSize: 24,
                  tooltip: "Edit",
                  onPressed: onEditPressed,
                ),
              if (isLinkButton == true && linkButton != null) linkButton
            ],
          ),
          ...content,
        ],
      ),
    );
  }

  Widget buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Future<List<Prescription>> getMyPrescriptions(int pId) async {
    List<Prescription> pList =
        await Provider.of<PrescriptionProvider>(context, listen: false)
            .getPrescriptionsByPatientIdWithDetails(pId);
    return pList;
  }
}
