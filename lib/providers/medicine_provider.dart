import 'dart:io';

import 'package:dispensary/models/medicine_model.dart';
import 'package:dispensary/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  int _medicineCountInDb = 0;
  final DatabaseService _databaseService;

  MedicineProvider(this._databaseService);

  List<Medicine> get medicines => _medicines;
  int get medicineCountInDb => _medicineCountInDb;
  // Medicines CRUD
  Future<void> loadAllMedicines() async {
    final List<Map<String, dynamic>> maps = await _databaseService.db.query('medicines');
    _medicines = maps.map((e) => Medicine.fromMap(e)).toList();
    notifyListeners();
  }

  void initList() {
    medicinesCount().then((value) {
      _medicineCountInDb = value;
      loadAllMedicines();
    });
  }

  Future<void> justLoadAllMedicines() async {
    final List<Map<String, dynamic>> maps = await _databaseService.db.query('medicines');
    _medicines = maps.map((e) => Medicine.fromMap(e)).toList();
  }

  Future<void> clearAllMedicines() async {
    _medicines.clear();
    notifyListeners();
  }

  Future<void> calculateFileSize() async {
    String dir = await getDatabasesPath();
    String filePath = join(dir, dotenv.env['DB_PATH'] ?? 'default_database-passive.db');
    final file = File(filePath);
    debugPrint('calculateFileSize----------------');
    // Check if the file exists
    if (await file.exists()) {
      // Get the file size in bytes
      final int bytes = await file.length();
      String fileSize;
      if (bytes < 1024) {
        fileSize = '${bytes}B'; // Bytes
      } else if (bytes < 1024 * 1024) {
        fileSize = '${(bytes / 1024).toStringAsFixed(2)} KB'; // Kilobytes
      } else if (bytes < 1024 * 1024 * 1024) {
        fileSize = '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB'; // Megabytes
      } else {
        fileSize = '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB'; // Gigabytes
      }
      debugPrint('fileSize----------------: $fileSize');
    } else {
      throw Exception('File not found: $filePath');
    }
  }

  void insertsDummyMedicines() async {
    await calculateFileSize();
    // Creating a list of Medicine objects for 10 commonly used medicines
    List<Medicine> medicines = [
      Medicine(
        sysMedicineId: 1,
        name: 'Aspirin',
        description: 'Pain reliever and anti-inflammatory drug',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 2,
        name: 'Ibuprofen',
        description: 'Nonsteroidal anti-inflammatory drug (NSAID)',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 3,
        name: 'Acetaminophen',
        description: 'Pain reliever and fever reducer',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 4,
        name: 'Amoxicillin',
        description: 'Antibiotic used to treat bacterial infections',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 5,
        name: 'Ciprofloxacin',
        description: 'Antibiotic used to treat various bacterial infections',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 6,
        name: 'Metformin',
        description: 'Oral diabetes medicine',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 7,
        name: 'Lisinopril',
        description: 'ACE inhibitor used to treat high blood pressure',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 8,
        name: 'Simvastatin',
        description: 'Cholesterol-lowering medication',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 9,
        name: 'Omeprazole',
        description: 'Proton pump inhibitor used to reduce stomach acid',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
      Medicine(
        sysMedicineId: 10,
        name: 'Hydrochlorothiazide',
        description: 'Diuretic used to treat high blood pressure',
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      ),
    ];

    print('Insert in db:');
    for (var medicine in medicines) {
      await _databaseService.db.insert('medicines', medicine.toMapWithoutId());
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
      where: 'sys_medicine_id = ?',
      whereArgs: [sysMedicineId],
    );
    notifyListeners();
  }

  void updateMedicineById(int sysMedicineId, Medicine medicine) async {
    await _databaseService.db.update(
      'medicines',
      medicine.toMapWithoutId(),
      where: 'sys_medicine_id = ?',
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

    final List<Map<String, dynamic>> result = await _databaseService.db.rawQuery(sql);

    // Extract the count from the result
    final int count = Sqflite.firstIntValue(result) ?? 0;

    return count;
  }

  Future<void> fetchNextPage(int startIndex, int pageSize) async {
    List<Map<String, dynamic>> result =
        await _databaseService.db.query('medicines', limit: startIndex, offset: pageSize);
    List<Medicine> nextPage = result.map((map) => Medicine.fromMap(map)).toList();
    if (nextPage.isEmpty != true) {
      _medicines.addAll(nextPage);
    }
    notifyListeners();
  }
}
