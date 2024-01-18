import 'prescription_line_model.dart';

class Prescription {
  final int sysPrescriptionId;
  final List<PrescriptionLine> prescriptionLines;
  final int patientId;
  final String details;
  final String diagnosis;
  final String problem;
  final DateTime createdDate;
  final DateTime updatedDate;
  final double totalAmount;
  final double paidAmount;

  Prescription({
    required this.sysPrescriptionId,
    required this.prescriptionLines,
    required this.patientId,
    required this.details,
    required this.diagnosis,
    required this.problem,
    required this.createdDate,
    required this.updatedDate,
    required this.totalAmount,
    required this.paidAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'sys_prescription_id': sysPrescriptionId,
      'prescription_lines':
          prescriptionLines.map((line) => line.toMap()).toList(),
      'patient_id': patientId,
      'details': details,
      'diagnosis': diagnosis,
      'problem': problem,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
    };
  }

  Map<String, dynamic> toMapIgnoreSysId() {
    return {
      'prescription_lines':
          prescriptionLines.map((line) => line.toMapIgnoreSysId()).toList(),
      'patient_id': patientId,
      'details': details,
      'diagnosis': diagnosis,
      'problem': problem,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      sysPrescriptionId: map['sys_prescription_id'],
      prescriptionLines: List<PrescriptionLine>.from(map['prescription_lines']
          .map((line) => PrescriptionLine.fromMap(line))),
      patientId: map['patient_id'],
      details: map['details'],
      diagnosis: map['diagnosis'],
      problem: map['problem'],
      createdDate: DateTime.parse(map['created_date']),
      updatedDate: DateTime.parse(map['updated_date']),
      totalAmount: map['total_amount'],
      paidAmount: map['paid_amount'],
    );
  }

  copyWith({required sysPrescriptionId}) {}
}
