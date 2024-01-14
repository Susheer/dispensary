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

class Guardian {
  late String name;
  late String mobileNumber;
  late String gender;
  late String address;
  late GuardianRelation relation; // New property

  Guardian({
    required this.name,
    required this.mobileNumber,
    required this.gender,
    required this.address,
    required this.relation,
  });

  factory Guardian.fromMap(Map<String, dynamic> map) {
    return Guardian(
      name: map['name'],
      mobileNumber: map['mobileNumber'],
      gender: map['gender'],
      address: map['address'],
      relation: GuardianRelation.values[map['relation']],
    );
  }
}

enum GuardianRelation {
  Parent,
  Spouse,
  Sibling,
  Other,
}
