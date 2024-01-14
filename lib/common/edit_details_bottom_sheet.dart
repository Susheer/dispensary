import 'package:flutter/material.dart';
import 'package:dispensary/models/patient.dart';

class EditDetailsBottomSheet extends StatefulWidget {
  final Patient patient;
  final Guardian guardian;
  final bool isEditingPatient;
  void Function(EditFormResponse) onSavePressed;
  EditDetailsBottomSheet({
    required this.patient,
    required this.guardian,
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
  Gender _selectedGender =
      Gender.Male; // Default value, you can adjust as needed

  void initState() {
    super.initState();
    // Auto-populate form fields with existing data
    _nameController.text =
        widget.isEditingPatient ? widget.patient.name : widget.guardian.name;
    _mobileController.text = widget.isEditingPatient
        ? widget.patient.mobileNumber
        : widget.guardian.mobileNumber;
    _addressController.text = widget.isEditingPatient
        ? widget.patient.address
        : widget.guardian.address;
    _selectedGender = widget.isEditingPatient
        ? widget.patient.gender
        : widget.guardian.gender;
    // Add similar logic for other form fields
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    // Dispose of other controllers...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit ${widget.isEditingPatient ? 'Patient' : 'Guardian'} Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add form fields for editing details
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _mobileController,
            decoration: InputDecoration(labelText: 'Mobile Number'),
          ),
          // Add form fields for editing details
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
          // Gender Radio Buttons
          genderWidget(),
          // Add other form fields as needed
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle form submission and update details
              _updateDetails();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget genderWidget() {
    return // Gender Radio Buttons
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('Gender:'),
          SizedBox(width: 16.0),
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
              Text('Male'),
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
              Text('Female'),
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
              Text('Other'),
            ],
          ),
          // Add more gender options as needed...
        ],
      ),
    );
  }

  void _updateDetails() {
    // Update patient details
    EditFormResponse res = EditFormResponse();
    res.address = _addressController.text;
    res.name = _nameController.text;
    res.gender = _selectedGender;
    res.allergies = widget.patient.allergies;
    res.mobileNumber = _mobileController.text;
    if (widget.isEditingPatient) {
      res.id = widget.patient.id;
      res.isPatient = true;
    } else {
      res.isPatient = false;
      res.relation = widget.guardian.relation;
    }
    widget.onSavePressed(res);
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
