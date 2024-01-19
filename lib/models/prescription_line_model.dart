import 'medicine_model.dart';

class PrescriptionLine {
  int sysPrescriptionLineId;
  Medicine medicine;
  String doses;
  String duration;
  String notes;
  String strength;

  PrescriptionLine({
    required int sysPrescriptionLineId,
    required this.medicine,
    required this.doses,
    required this.duration,
    required this.notes,
    required this.strength,
  }) : sysPrescriptionLineId = sysPrescriptionLineId;

  PrescriptionLine copyWith({
    int? sysPrescriptionLineId,
    Medicine? medicine,
    String? doses,
    String? duration,
    String? notes,
    String? strength,
  }) {
    return PrescriptionLine(
      sysPrescriptionLineId:
          sysPrescriptionLineId ?? this.sysPrescriptionLineId,
      medicine: medicine ?? this.medicine,
      doses: doses ?? this.doses,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      strength: strength ?? this.strength,
    );
  }

// Setter for sysPrescriptionLineId
  set setSysPrescriptionLineId(int newSysPrescriptionLineId) {
    sysPrescriptionLineId = newSysPrescriptionLineId;
  }

  // Setter for medicine
  set setMedicine(Medicine newMedicine) {
    medicine = newMedicine;
  }

  // Setter for doses
  set setDoses(String newDoses) {
    doses = newDoses;
  }

  // Setter for duration
  set setDuration(String newDuration) {
    duration = newDuration;
  }

  // Setter for notes
  set setNotes(String newNotes) {
    notes = newNotes;
  }

  // Setter for strength
  set setStrength(String newStrength) {
    strength = newStrength;
  }

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

  Map<String, dynamic> toMapIgnoreSysId() {
    return {
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
