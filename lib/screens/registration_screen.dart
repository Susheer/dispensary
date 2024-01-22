// registration_screen.dart
import 'package:dispensary/models/patient.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<Step> _steps = [];
  int _currentStep = 0;
  late String name;
  late String mobileNumber;
  late Gender gender = Gender.Other;
  late String address;
  late List<String> allergies;

  late String? guardianName;
  late String? guardianMobileNumber;
  late Gender guardianGender = Gender.Other;
  late String? guardianAddress;
  late GuardianRelation relation = GuardianRelation.Other;

  Widget patientGenderWidget() {
    return // Gender Radio Buttons
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Radio(
                value: Gender.Male,
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = Gender.Male;
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
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = Gender.Female;
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
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = Gender.Other;
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

  Widget guardianGenderWidget() {
    return // Gender Radio Buttons
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Radio(
                value: Gender.Male,
                groupValue: guardianGender,
                onChanged: (value) {
                  setState(() {
                    guardianGender = Gender.Male;
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
                groupValue: guardianGender,
                onChanged: (value) {
                  setState(() {
                    guardianGender = Gender.Female;
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
                groupValue: guardianGender,
                onChanged: (value) {
                  setState(() {
                    guardianGender = Gender.Other;
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

  Widget guardianRadioOption(GuardianRelation value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: relation,
          onChanged: (newValue) {
            setState(() {
              relation = value;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget buildSection({
    required String title,
    required List<Widget> content,
    bool enableEdit = false,
    VoidCallback? onEditPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          ...content,
        ],
      ),
    );
  }

  Step _buildStep1() {
    return Step(
      isActive: _currentStep == 0,
      title: const Text('Patient details'),
      content: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onSaved: (value) {
              name = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mobile number'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Mobile number';
              }
              return null;
            },
            onSaved: (value) {
              mobileNumber = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
            onSaved: (value) {
              address = value!;
            },
          ),
          patientGenderWidget(),
        ],
      ),
    );
  }

  Step _buildStep2() {
    return Step(
      title: const Text('Medical history'),
      isActive: _currentStep == 1,
      content: Column(
        children: [
          TextFormField(
            decoration:
                const InputDecoration(labelText: 'Allergies (comma-separated)'),
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
            onSaved: (value) {
              allergies = value!.split(',');
            },
          ),
        ],
      ),
    );
  }

  Step _buildStep3() {
    return Step(
      isActive: _currentStep == 2,
      title: const Text('Guardian'),
      content: Column(
        children: [
          buildSection(title: 'Fill details', content: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Guardian Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter guardian name';
                }
                return null;
              },
              onSaved: (value) {
                guardianName = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Guardian's Mobile"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter guardian's Mobile";
                }
                return null;
              },
              onSaved: (value) {
                guardianMobileNumber = value!;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: "Guardian's address"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter guardian's address";
                }
                return null;
              },
              onSaved: (value) {
                guardianAddress = value!;
              },
            ),
            guardianGenderWidget(),
          ]),
          buildSection(title: 'Relation with patient', content: [
            Row(children: [
              guardianRadioOption(GuardianRelation.Parent, 'Parent'),
              guardianRadioOption(GuardianRelation.Spouse, 'Spouse')
            ]),
            Row(children: [
              guardianRadioOption(GuardianRelation.Sibling, 'Sibling'),
              guardianRadioOption(GuardianRelation.Other, 'Other'),
            ]),
          ])
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await Provider.of<PatientProvider>(context, listen: false)
          .registerPatient(
              name: name,
              mobileNumber: mobileNumber,
              gender: Patient.parseGenderToString(gender),
              address: address,
              allergies: allergies,
              guardianName: guardianName,
              guardianMobileNumber: guardianMobileNumber,
              guardianAddress: guardianAddress,
              guardianGender: Patient.parseGenderToString(guardianGender),
              relation: Patient.parseRelationToString(relation));
      _navigateToReview();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully'),
        ),
      );
      setState(() {
        name = "";
        mobileNumber = "";
        gender = Gender.Other;
        address = "";
        allergies = [];
        guardianName = "";
        guardianMobileNumber = "";
        guardianAddress = "";
        guardianGender = Gender.Other;
        relation = GuardianRelation.Other;
      });
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill all the details.'),
        ),
      );
    }
  }

  void _navigateToReview() {
    // Navigate to the review page or perform other actions as needed
    // You can use Navigator.push or showDialog to show a review page.
  }

  void _initializeSteps() {
    _steps = [
      _buildStep1(),
      _buildStep2(),
      _buildStep3(),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initializeSteps();
    return Form(
      key: _formKey,
      child: Theme(
        data: ThemeData(
            colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
        child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepTapped: (step) {
              setState(() {
                _currentStep = step;
              });
            },
            onStepContinue: () {
              if (_currentStep < _steps.length - 1) {
                setState(() {
                  _currentStep += 1;
                });
              } else {
                // Last step, submit the form
                _submitForm();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep -= 1;
                });
              }
            },
            steps: _steps),
      ),
    );
  }
}
