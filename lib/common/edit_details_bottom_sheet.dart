import 'package:flutter/material.dart';
import 'package:dispensary/models/patient.dart';

class EditDetailsBottomSheet extends StatefulWidget {
  final Patient patient;
  final bool isEditingPatient;
  void Function(Patient) onSavePressed;
  EditDetailsBottomSheet({
    required this.patient,
    required this.isEditingPatient,
    required this.onSavePressed,
  });

  @override
  _EditDetailsBottomSheetState createState() => _EditDetailsBottomSheetState();
}

class _EditDetailsBottomSheetState extends State<EditDetailsBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Gender _selectedGender =
      Gender.Male; // Default value, you can adjust as needed

  void initState() {
    super.initState();
    // Auto-populate form fields with existing data
    _nameController.text = widget.isEditingPatient
        ? widget.patient.name
        : widget.patient.guardianName ?? "";
    _mobileController.text = widget.isEditingPatient
        ? widget.patient.mobileNumber
        : widget.patient.guardianMobileNumber ?? "";
    _addressController.text = widget.isEditingPatient
        ? widget.patient.address
        : widget.patient.guardianAddress ?? "";
    _selectedGender = widget.isEditingPatient
        ? widget.patient.gender
        : widget.patient.guardianGender ?? Gender.Other;
    if (widget.isEditingPatient == true) {
      _allergiesController.text = widget.patient.allergies.join(',');
    }

    // Add similar logic for other form fields
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose of controllers when the widget is disposed
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _allergiesController.dispose();
    // Dispose of other controllers...
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit ${widget.isEditingPatient ? 'Patient' : 'Guardian'} Details',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Add form fields for editing details
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name.';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid mobile number.';
                    }
                    return null;
                  }),
              // Add form fields for editing details
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid address.';
                  }
                  return null;
                },
              ),
              if (widget.isEditingPatient == true)
                TextFormField(
                  controller: _allergiesController,
                  decoration: const InputDecoration(labelText: 'Allergies'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter allergies.';
                    }

                    List<String> allergyList = value.split(',');

                    if (allergyList.any((allergy) => allergy.trim().isEmpty)) {
                      return 'Invalid format. Please enter valid, comma-separated allergies.';
                    }

                    return null;
                  },
                ),
              // Gender Radio Buttons
              genderWidget(),
              // Add other form fields as needed
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission and update details
                  if (_formKey.currentState!.validate()) {
                    _updateDetails();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget genderWidget() {
    return // Gender Radio Buttons
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text('Gender:'),
          const SizedBox(width: 16.0),
          Row(
            children: [
              Radio(
                value: Gender.Male,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value as Gender;
                  });
                },
              ),
              const Text('Male'),
            ],
          ),
          Row(
            children: [
              Radio(
                value: Gender.Female,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value as Gender;
                  });
                },
              ),
              const Text('Female'),
            ],
          ),
          Row(
            children: [
              Radio(
                value: Gender.Other,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value as Gender;
                  });
                },
              ),
              const Text('Other'),
            ],
          ),
          // Add more gender options as needed...
        ],
      ),
    );
  }

  void _updateDetails() {
    Patient newP;
    Map<String, dynamic> obj = Map();
    // Update patient details
    obj['id'] = widget.patient.id;
    if (widget.isEditingPatient) {
      obj['name'] = _nameController.text;
      obj['mobileNumber'] = _mobileController.text;
      obj['address'] = _addressController.text;
      obj['gender'] = Patient.parseGenderToString(_selectedGender);
      obj['allergies'] = _allergiesController.text;
      // keep guardian info as it was.
      obj['guardianName'] = widget.patient.guardianName ?? "";
      obj['guardianMobileNumber'] = widget.patient.guardianMobileNumber ?? "";
      obj['guardianAddress'] = widget.patient.guardianAddress ?? "";
      obj['guardianRelation'] = Patient.parseRelationToString(
          widget.patient.relation ?? GuardianRelation.Other);
      obj['guardianGender'] =
          Patient.parseGenderToString(widget.patient.gender);
    } else {
      // keep patient info as it was.
      obj['mobileNumber'] = widget.patient.mobileNumber;
      obj["name"] = widget.patient.name;
      obj["gender"] = Patient.parseGenderToString(widget.patient.gender);
      obj["address"] = widget.patient.address;
      obj["allergies"] = widget.patient.allergies.join(",");

      // update only guardian specific info
      obj['guardianName'] = _nameController.text;
      obj['guardianMobileNumber'] = _mobileController.text;
      obj['guardianAddress'] = _addressController.text;
      obj['guardianRelation'] = Patient.parseRelationToString(
          widget.patient.relation ?? GuardianRelation.Other);
      obj['guardianGender'] = Patient.parseGenderToString(_selectedGender);
    }
    newP = Patient.fromMap(obj);
    widget.onSavePressed(newP);
    // Close the bottom sheet
    Navigator.of(context).pop();
  }
}

class EditFormResponse {
  late int id;
  late String name;
  late Gender gender;
  late String address;
  late String mobileNumber;
  late List<String> allergies;
  late GuardianRelation? relation;
  late bool isPatient;
}
