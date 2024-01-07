// database_service.dart
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
      'name': name,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'address': address,
      'allergies': allergies.join(','),
    });
  }

  // Add methods for CRUD operations
}
