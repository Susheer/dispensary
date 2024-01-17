import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  int medicineCountInDb = 0;
  final DatabaseService _databaseService;

  MedicineProvider(this._databaseService) {
    medicinesCount().then((value) {
      medicineCountInDb = value;
    });
    loadAllMedicines();
  }

  List<Medicine> get medicines => _medicines;

  // Medicines CRUD
  void loadAllMedicines() async {
    final List<Map<String, dynamic>> maps =
        await _databaseService.db.query('medicines');
    _medicines = maps.map((e) => Medicine.fromMap(e)).toList();
    notifyListeners();
  }

  void insertsDummyMedicines() async {
    List<Medicine> dummyMedicines = [];

    for (int i = 1; i <= 500; i++) {
      Medicine medicineObj = Medicine(
        sysMedicineId: i,
        name: 'Medicine $i',
        description: 'Description for Medicine $i',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );
      await _databaseService.db
          .insert('medicines', medicineObj.toMapWithoutId());
    }
    notifyListeners();
  }

  void deleteAllMedicines() async {
    await _databaseService.db.delete('medicines');
    notifyListeners();
  }

  void deleteMedicineById(int sysMedicineId) async {
    await _databaseService.db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [sysMedicineId],
    );
    notifyListeners();
  }

  void updateMedicineById(int sysMedicineId, Medicine medicine) async {
    await _databaseService.db.update(
      'medicines',
      medicine.toMapWithoutId(),
      where: 'id = ?',
      whereArgs: [sysMedicineId],
    );
    notifyListeners();
  }

  Future<void> insertMedicine(Medicine medicine) async {
    await _databaseService.db.insert(
      'medicines',
      medicine.toMapWithoutId(),
    );
    _medicines.insert(0, medicine);
    notifyListeners();
  }

  Future<Medicine?> getMedicineById(int sysMedicineId) async {
    List<Map<String, dynamic>> results = await _databaseService.db.query(
      'medicines',
      where: 'id = ?',
      whereArgs: [sysMedicineId],
    );
    // Check if the results list is not empty
    if (results.isNotEmpty) {
      // Convert the result to a Patient object
      return Medicine.fromMap(results.first);
    }

    // If patient not found, return null
    return null;
  }

  Future<int> medicinesCount() async {
    // Your SQL query to get the count
    const String sql = 'SELECT COUNT(*) FROM medicines';

    final List<Map<String, dynamic>> result =
        await _databaseService.db.rawQuery(sql);

    // Extract the count from the result
    final int count = Sqflite.firstIntValue(result) ?? 0;

    return count;
  }
}
