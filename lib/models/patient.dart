// patient.dart
class Patient {
  final int id;
  final String name;
  final String mobileNumber;
  final String gender;
  final String address;
  final List<String> allergies;

  Patient({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.gender,
    required this.address,
    required this.allergies,
  });
}
