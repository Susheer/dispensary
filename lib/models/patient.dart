// patient_model.dart
class Patient {
  late int id;
  late String name;
  late String mobileNumber;
  late String gender;
  late String address;
  late List<String> allergies;

  Patient({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.gender,
    required this.address,
    required this.allergies,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      mobileNumber: map['mobileNumber'],
      gender: map['gender'],
      address: map['address'],
      allergies: map['allergies']?.split(',').toList() ?? [],
    );
  }
}
