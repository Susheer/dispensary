// database_service.dart
import 'dart:io';
import 'package:dispensary/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  late Database _database;
  static String getDatabaseName() {
    return 'clinic.db';
  }

  Future<void> initializeDatabase() async {
    // Get the path to the documents directory
    var documentsDirectory = await getDatabasesPath();
    String databaseLocation = join(documentsDirectory, DatabaseService.getDatabaseName());
    debugPrint('Database location $databaseLocation');

    // Open the database
    _database = await openDatabase(
      databaseLocation,
      version: 1,
      onCreate: (db, version) {
        debugPrint("database created successfully");
        db.execute('''
          CREATE TABLE IF NOT EXISTS patients(
            id INTEGER PRIMARY KEY,
            name TEXT,
            mobileNumber TEXT,
            gender TEXT,
            address TEXT,
            allergies TEXT,
            guardianName TEXT,
            guardianMobileNumber TEXT,
            guardianGender TEXT,
            guardianAddress TEXT,
            guardianRelation TEXT,
            created_date TEXT,
            updated_date TEXT,
            scheduled_date TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE IF NOT EXISTS prescriptions (
            sys_prescription_id INTEGER PRIMARY KEY,
            patient_id INTEGER,
            diagnosis TEXT,
            chief_complaint TEXT,
            created_date TEXT,
            updated_date TEXT,
            total_amount REAL,
            paid_amount REAL
            )
          ''');
        db.execute('''
          CREATE TABLE IF NOT EXISTS medicines (
            sys_medicine_id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            created_date TEXT,
            updated_date TEXT
         )
         ''');

        db.execute('''
          CREATE TABLE IF NOT EXISTS prescription_line (
            sys_prescription_line_id INTEGER PRIMARY KEY,
            medicine_id INTEGER,  
            prescription_id INTEGER, 
            doses TEXT,
            duration TEXT,
            notes TEXT,
            strength TEXT,
            FOREIGN KEY (medicine_id) REFERENCES medicines(sys_medicine_id),
            FOREIGN KEY (prescription_id) REFERENCES prescriptions(sys_prescription_id)
         )
         ''');
      },
    );
  }

  Database get db => _database;
  Future<void> savePatient({
    required String name,
    required String mobileNumber,
    required String gender,
    required String address,
    required List<String> allergies,
    required String guardianName,
    required String guardianMobileNumber,
    required String guardianGender,
    required String guardianAddress,
    required String guardianRelation,
    required String updatedDate,
    required String createdDate,
    required String? scheduledDate,
  }) async {
    await _database.insert('patients', {
      'name': _wrapWithQuotes(name),
      'mobileNumber': _wrapWithQuotes(mobileNumber),
      'gender': _wrapWithQuotes(gender),
      'address': _wrapWithQuotes(address),
      'allergies': _wrapWithQuotes(allergies.join(',')),
      'guardianName': _wrapWithQuotes(guardianName),
      'guardianMobileNumber': _wrapWithQuotes(guardianMobileNumber),
      'guardianGender': _wrapWithQuotes(guardianGender),
      'guardianAddress': _wrapWithQuotes(guardianAddress),
      'guardianRelation': _wrapWithQuotes(guardianRelation),
      'created_date': _wrapWithQuotes(createdDate),
      'updated_date': _wrapWithQuotes(updatedDate),
      'scheduled_date': _wrapWithQuotes(scheduledDate ?? ""),
    });
  }

  Future<int> updatePatientByPatientId({required int id, required Map<String, String> obj}) async {
    int rowEffected = await _database.update('patients', obj, where: "id = ?", whereArgs: [id]);
    return rowEffected;
  }

  // Wrap a string value with single quotes
  String _wrapWithQuotes(String value) {
    return value;
  }

  Future<List<Patient>> getAllPatients() async {
    List<Map<String, dynamic>> result = await _database.query('patients');
    return result.map((map) => Patient.fromMap(map)).toList();
  }

// Fetch a paginated list of patients from the database
  Future<List<Patient>> fetchPaginatedPatients(int offset, int pageSize) async {
    List<Map<String, dynamic>> result = await _database.query('patients',
        orderBy: "updated_date DESC", limit: pageSize, offset: offset);
    return result.map((map) => Patient.fromMap(map)).toList();
  }

  Future<void> deleteAllPatients() async {
    // Your SQL query to delete all records from the patients table
    const String sql = 'DELETE FROM patients';
    await _database.execute(sql);
  }

  Future<int> getPatientsCount() async {
    const String sql = 'SELECT COUNT(*) FROM patients';
    final List<Map<String, dynamic>> result = await _database.rawQuery(sql);
    // Extract the count from the result
    final int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }

  Future<bool> deletePatientById(int patientId) async {
    await _database.delete(
      'patients',
      where: 'id = ?',
      whereArgs: [patientId],
    );
    return true;
  }

  Future<Patient?> fetchPatientById(int patientId) async {
    // Fetch patient details from the database based on patientId
    List<Map<String, dynamic>> results = await _database.query(
      'patients',
      where: 'id = ?',
      whereArgs: [patientId],
    );

    // Check if the results list is not empty
    if (results.isNotEmpty) {
      // Convert the result to a Patient object
      return Patient.fromMap(results.first);
    }

    // If patient not found, return null
    return null;
  }

  // Function to delete the database and clear its contents
  Future<void> deleteDatabaseAndClear() async {
    debugPrint("Deleting database...");
    var documentsDirectory = await getDatabasesPath();
    String databasePath = join(documentsDirectory, getDatabaseName());
    // Close the database before deleting
    if (_database.isOpen) {
      debugPrint("Closing database...");
      await _database.close();
    }

    await deleteDatabase(databasePath);
    debugPrint("Database deleted successfully");
    debugPrint("Re-initializing database....");
    await initializeDatabase();
  }

  static Future<String> calculateDatabaseSize() async {
    debugPrint('calculating file size on disk...');
    String databaseDirectory = await getDatabasesPath();
    String filePath = join(databaseDirectory, DatabaseService.getDatabaseName());
    final file = File(filePath);
    debugPrint('Check if the file exists');
    if (await file.exists()) {
      debugPrint('Get the file size in bytes');
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
      return fileSize;
    } else {
      debugPrint('file does not exists on disk');
      return 'Invalid';
    }
  }

  Future<Map<String, dynamic>> calculateTotalsInBatches(int batchSize) async {
    int offset = 0;
    double total = 0;
    double paid = 0;

    while (true) {
      // Fetch patient IDs in batches
      final patientIds = await db.rawQuery('''
      SELECT id 
      FROM patients 
      WHERE DATE(scheduled_date) = DATE('now', '+1 day')
      LIMIT ? OFFSET ?
    ''', [batchSize, offset]);

      // Break the loop if no more patient IDs are found
      if (patientIds.isEmpty) break;

      // Extract patient IDs for the current batch
      final idList = patientIds.map((row) => row['id']).toList();

      // Calculate the totals for the current batch of patient IDs
      final batchResult = await db.rawQuery('''
      SELECT 
        SUM(total_amount) AS batchTotal,
        SUM(paid_amount) AS batchPaid
      FROM prescriptions
      WHERE patient_id IN (${List.filled(idList.length, '?').join(',')})
    ''', idList);

      // Add the batch results to the running totals
      final batchTotal = batchResult.first['batchTotal'] as double? ?? 0;
      final batchPaid = batchResult.first['batchPaid'] as double? ?? 0;

      total += batchTotal;
      paid += batchPaid;

      // Move to the next batch
      offset += batchSize;
    }

    // Calculate the pending amount
    final pending = total - paid;

    // Return the final result
    return {'total': total, 'paid': paid, 'pending': pending};
  }
}
