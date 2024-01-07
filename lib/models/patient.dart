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
}
