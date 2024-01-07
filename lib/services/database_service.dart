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
        // ...
      },
    );
  }

  // Add methods for CRUD operations
}
