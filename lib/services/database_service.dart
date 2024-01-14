// database_service.dart
import 'package:dispensary/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  late Database _database;

  Future<void> initializeDatabase() async {
    // Get the path to the documents directory
    var documentsDirectory = await getDatabasesPath();
    String dbPath = join(
        documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database.db');

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
            allergies TEXT
          )
        ''');
        // ...
      },
    );
  }

  Future<void> savePatient({
    required String name,
    required String mobileNumber,
    required String gender,
    required String address,
    required List<String> allergies,
  }) async {
    await _database.insert('patients', {
      'name': _wrapWithQuotes(name),
      'mobileNumber': _wrapWithQuotes(mobileNumber),
      'gender': _wrapWithQuotes(gender),
      'address': _wrapWithQuotes(address),
      'allergies': _wrapWithQuotes(allergies.join(',')),
    });
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
    List<Map<String, dynamic>> result =
        await _database.query('patients', limit: pageSize, offset: offset);
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
// Add methods for CRUD operations
}
