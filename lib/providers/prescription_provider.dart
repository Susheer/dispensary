import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/models/prescription_line_model.dart';
import 'package:dispensary/models/prescription_model.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class PrescriptionProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  PrescriptionProvider(this._databaseService);

  // Prescription CRUD methods

  // Future<int> insertPrescription(Prescription prescription) async {

  //   return await _databaseService.insert('prescriptions', prescription.toMap());
  // }

  // Future<List<Prescription>> getAllPrescriptions() async {
  //   final List<Map<String, dynamic>> maps =
  //       await _databaseService.query('prescriptions');
  //   return List.generate(maps.length, (i) => Prescription.fromMap(maps[i]));
  // }

  // Future<int> updatePrescription(Prescription prescription) async {
  //   return await _databaseService.update('prescriptions', prescription.toMap(),
  //       where: 'sys_prescription_id = ?',
  //       whereArgs: [prescription.sysPrescriptionId]);
  // }

  // Future<int> deletePrescription(int prescriptionId) async {
  //   return await _databaseService.delete('prescriptions',
  //       where: 'sys_prescription_id = ?', whereArgs: [prescriptionId]);
  // }

  // PrescriptionLine CRUD methods within PrescriptionProvider

  // Future<int> insertPrescriptionLine(PrescriptionLine prescriptionLine) async {
  //   return await _databaseService.insert(
  //       'prescription_lines', prescriptionLine.toMap);
  // }

  // Future<List<PrescriptionLine>> getAllPrescriptionLines() async {
  //   final List<Map<String, dynamic>> maps =
  //       await _databaseService.query('prescription_lines');
  //   return List.generate(maps.length, (i) => PrescriptionLine.fromMap(maps[i]));
  // }

  // Future<int> updatePrescriptionLine(PrescriptionLine prescriptionLine) async {
  //   return await _databaseService.update(
  //       'prescription_lines', prescriptionLine.toMap(),
  //       where: 'sys_prescription_line_id = ?',
  //       whereArgs: [prescriptionLine.sysPrescriptionLineId]);
  // }

  // Future<int> deletePrescriptionLine(int prescriptionLineId) async {
  //   return await _databaseService.delete('prescription_lines',
  //       where: 'sys_prescription_line_id = ?', whereArgs: [prescriptionLineId]);
  // }
}
