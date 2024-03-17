// database_service.dart
import 'package:dispensary/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

class DatabaseService {
  late Database _database;

  Future<void> initializeDatabase() async {
    // Get the path to the documents directory
    var documentsDirectory = await getDatabasesPath();
    String dbPath = join(
        documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database.db');
    debugPrint("------DB PAth $dbPath------");

    // Open the database
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        debugPrint("-----------Database is created-----------");
        // Create tables and schema
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

        // ...
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

  Future<int> updatePatientByPatientId(
      {required int id, required Map<String, String> obj}) async {
    int rowEffected = await _database
        .update('patients', obj, where: "id = ?", whereArgs: [id]);
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
    if (_database == null) {
      throw Exception(
          'Database not initialized. Call initializeDatabase first.');
    }
    List<Map<String, dynamic>> result = await _database.query('patients',
        orderBy: "updated_date DESC", limit: pageSize, offset: offset);
    return result.map((map) => Patient.fromMap(map)).toList();
  }

  Future<void> deleteAllPatients() async {
    if (_database == null) {
      throw Exception(
          'Database not initialized. Call initializeDatabase first.');
    }

    // Your SQL query to delete all records from the patients table
    final String sql = 'DELETE FROM patients';

    await _database.execute(sql);
  }

  Future<int> getPatientsCount() async {
    if (_database == null) {
      throw Exception(
          'Database not initialized. Call initializeDatabase first.');
    }

    // Your SQL query to get the count
    final String sql = 'SELECT COUNT(*) FROM patients';

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
    debugPrint("deleteDatabaseAndClear: Invoked");
    debugPrint("deleteDatabaseAndClear: Start");
    var documentsDirectory = await getDatabasesPath();
    String databasePath = join(
        documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database.db');
    debugPrint("deleteDatabaseAndClear: path $documentsDirectory");
    debugPrint("isDatabaseOpen:  ${_database.isOpen}");
    debugPrint("closing db");
    // Close the database before deleting
    if (_database.isOpen) {
      await _database.close();
    }
    debugPrint("isDatabaseOpen:  ${_database.isOpen}");
    debugPrint("------Deleting Db------");
    // Delete the database file
    await deleteDatabase(databasePath);
    // Reinitialize the database if needed
    debugPrint("------Re creating Db------");
    await initializeDatabase();
  }
}
