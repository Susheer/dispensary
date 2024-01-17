import 'medicine_model.dart';

class PrescriptionLine {
  final int sysPrescriptionLineId;
  final Medicine medicine;
  final String doses;
  final String duration;
  final String notes;
  final String strength;

  PrescriptionLine({
    required int sysPrescriptionLineId,
    required this.medicine,
    required this.doses,
    required this.duration,
    required this.notes,
    required this.strength,
  }) : sysPrescriptionLineId = sysPrescriptionLineId;

  Map<String, dynamic> toMap() {
    return {
      'sys_prescription_line_id': sysPrescriptionLineId,
      'medicine': medicine.toMap(),
      'doses': doses,
      'duration': duration,
      'notes': notes,
      'strength': strength,
    };
  }

  factory PrescriptionLine.fromMap(Map<String, dynamic> map) {
    return PrescriptionLine(
      sysPrescriptionLineId: map['sys_prescription_line_id'],
      medicine: Medicine.fromMap(map['medicine']),
      doses: map['doses'],
      duration: map['duration'],
      notes: map['notes'],
      strength: map['strength'],
    );
  }
}
