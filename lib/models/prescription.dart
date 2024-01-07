// prescription.dart
class Prescription {
  final int id;
  final int patientId;
  final String details;
  final double consultingFee;

  Prescription({
    required this.id,
    required this.patientId,
    required this.details,
    required this.consultingFee,
  });
}
