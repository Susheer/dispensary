import 'prescription_line_model.dart';

class Prescription {
  late int sysPrescriptionId;
  late List<PrescriptionLine> prescriptionLines;
  late int patientId;
  late String details;
  late String diagnosis;
  late String problem;
  late DateTime createdDate;
  late DateTime updatedDate;
  late double totalAmount;
  late double paidAmount;

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

  Prescription.init() {
    sysPrescriptionId = 0;
    prescriptionLines = [];
    patientId = 0;
    details = "";
    diagnosis = "";
    problem = "";
    createdDate = DateTime.now();
    updatedDate = DateTime.now();
    totalAmount = 0.0;
    paidAmount = 0.0;
  }

  // CopyWith method to create a new instance with modified values
  Prescription copyWith({
    int? sysPrescriptionId,
    List<PrescriptionLine>? prescriptionLines,
    int? patientId,
    String? details,
    String? diagnosis,
    String? problem,
    DateTime? createdDate,
    DateTime? updatedDate,
    double? totalAmount,
    double? paidAmount,
  }) {
    return Prescription(
      sysPrescriptionId: sysPrescriptionId ?? this.sysPrescriptionId,
      prescriptionLines: prescriptionLines ?? this.prescriptionLines,
      patientId: patientId ?? this.patientId,
      details: details ?? this.details,
      diagnosis: diagnosis ?? this.diagnosis,
      problem: problem ?? this.problem,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }

// Setter for prescriptionLines
  set setPrescriptionLines(List<PrescriptionLine> newPrescriptionLines) {
    prescriptionLines = newPrescriptionLines;
  }

  // Getter for prescriptionLines
  List<PrescriptionLine> get getPrescriptionLines {
    return prescriptionLines;
  }

  // Setter for patientId
  set setPatientId(int newPatientId) {
    patientId = newPatientId;
  }

  // Setter for details
  set setDetails(String newDetails) {
    details = newDetails;
  }

  // Setter for diagnosis
  set setDiagnosis(String newDiagnosis) {
    diagnosis = newDiagnosis;
  }

  // Setter for problem
  set setProblem(String newProblem) {
    problem = newProblem;
  }

  // Setter for createdDate
  set setCreatedDate(DateTime newCreatedDate) {
    createdDate = newCreatedDate;
  }

  // Setter for updatedDate
  set setUpdatedDate(DateTime newUpdatedDate) {
    updatedDate = newUpdatedDate;
  }

  // Setter for totalAmount
  set setTotalAmount(double newTotalAmount) {
    totalAmount = newTotalAmount;
  }

  // Setter for paidAmount
  set setPaidAmount(double newPaidAmount) {
    paidAmount = newPaidAmount;
  }

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
    late List<PrescriptionLine> pLines = [];
    if (map.containsKey('prescription_lines') &&
        map['prescription_lines'] != null &&
        map['prescription_lines']!.isNotEmpty) {
      pLines = map['prescription_lines']
          .map((line) => PrescriptionLine.fromMap(line));
    }

    return Prescription(
      sysPrescriptionId: map['sys_prescription_id'],
      prescriptionLines: pLines,
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
}
