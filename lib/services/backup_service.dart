import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BackupService {
  Future<String> getdbPath() async {
    var documentsDirectory = await getDatabasesPath();
    String dbPath = join(documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database.db');
    return dbPath;
  }

  Future<drive.DriveApi?> _getDriveApi(GoogleSignInAccount googleUser) async {
    final headers = await googleUser.authHeaders;

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

// Function to create a backup of the SQLite database file
  Future<File?> _createDatabaseBackup(File databaseFile) async {
    try {
      // Read database file
      List<int> fileBytes = await databaseFile.readAsBytes();

      // Create backup file
      final backupFileName = "${basenameWithoutExtension(databaseFile.path)}_backup.db";
      final backupFile = File("${databaseFile.parent.path}/$backupFileName");

      // Write database content to backup file
      await backupFile.writeAsBytes(fileBytes);

      ('Database backup created successfully: ${backupFile.path}');
      return backupFile;
    } catch (e) {
      debugPrint('Error creating database backup: $e');
      return null;
    }
  }

  // Function to upload the database backup file to Google Drive
  Future<void> _uploadDatabaseBackupToDrive(
      drive.DriveApi driveApi, File backupFile, String folderId) async {
    try {
      debugPrint("uploadDatabaseBackupToDrive Invoked");
      // Read backup file
      List<int> fileBytes = await backupFile.readAsBytes();
      // Set up media stream
      final mediaStream = Stream<List<int>>.fromIterable([fileBytes]);

      // Set up File info
      final driveFile = drive.File();

      driveFile.name = basename(backupFile.path); // Use backup file name
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = [folderId]; // Assuming folderId is defined elsewhere

      // Upload
      final media = drive.Media(mediaStream, fileBytes.length);
      final response = await driveApi.files.create(driveFile, uploadMedia: media);
      debugPrint('Database backup uploaded successfully: ${response.name}');
    } catch (e) {
      debugPrint('Error uploading database backup: $e');
    }
  }

  Future<void> uploadBackup(BuildContext context, GoogleSignInAccount account) async {
    debugPrint("uploadBackup Invoked");
    try {
      final driveApi = await _getDriveApi(account);
      if (driveApi == null) {
        return;
      }
      debugPrint("driveApi created");
      // Not allow a user to do something else
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(seconds: 2),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) => Center(
          child: const CircularProgressIndicator(),
        ),
      );

      // db path
      var documentsDirectory = await getDatabasesPath();
      String dbPath = join(documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database.db');
      debugPrint("[Database Path] $dbPath");
      final databaseFile = File(dbPath);
      // createDb backup
      File? backupFile = await _createDatabaseBackup(databaseFile);

      if (backupFile != null) {
        // Upload backup to Google Drive
        debugPrint("[Backup database path] ${backupFile.path}");
        await _uploadDatabaseBackupToDrive(driveApi, backupFile, 'appDataFolder');
      } else {
        debugPrint('Database backup creation failed. Upload aborted.');
      }
      // simulate a slow process
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      // Remove a dialog
      Navigator.pop(context);
    }
  }

  Future<drive.FileList?> showAllBackups(GoogleSignInAccount account) async {
    final driveApi = await _getDriveApi(account);
    if (driveApi == null) {
      return null;
    }

    var ll = await driveApi.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id, name, createdTime, size, version)',
    );

    return ll;
  }

  Future<void> deleteFile(GoogleSignInAccount account, String fileId) async {
    final driveApi = await _getDriveApi(account);
    if (driveApi == null) {
      return null;
    }
    await driveApi.files.delete(fileId);
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = new http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
