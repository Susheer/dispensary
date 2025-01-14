import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';
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

  blockScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(seconds: 2),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation, secondaryAnimation) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
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
      blockScreen(context);

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
      $fields: 'files(id, name, createdTime, size, version,mimeType)',
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

  Future<void> applyBackup(GoogleSignInAccount account, String fileId) async {
    debugPrint('invoked');

    var documentsDirectory = await getDatabasesPath();
    String dbPath = join(documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database-passive.db');

    final localDriveApi = await _getDriveApi(account);
    if (localDriveApi == null) {
      return;
    }

    drive.Media res = await localDriveApi.files
        .get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

    // Initialize total bytes downloaded
    int totalDownloaded = 0;

    // Open a file for writing
    final file = File(dbPath);
    final fileSink = file.openWrite();

    // Listen to the stream and process chunks of data
    await for (final chunk in res.stream) {
      // Write chunk to file
      fileSink.add(chunk);

      // Update total downloaded
      totalDownloaded += chunk.length;

      // Display progress
      debugPrint('Downloaded $totalDownloaded bytes');
    }

    // Close the file sink
    await fileSink.close();

    debugPrint('Backup applied successfully to $dbPath');
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {}

  @override
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    headers ??= {};
    headers.addAll(_headers);
    return _client.delete(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    headers ??= {};
    headers.addAll(headers);
    return _client.get(url, headers: headers);
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    headers ??= {};
    headers.addAll(headers);
    return _client.head(url, headers: headers);
  }

  @override
  Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    headers ??= {};
    headers.addAll(headers);
    return _client.patch(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    headers ??= {};
    headers.addAll(headers);
    return _client.post(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    headers ??= {};
    headers.addAll(headers);
    return _client.put(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    headers ??= {};
    headers.addAll(headers);
    return _client.read(url, headers: headers);
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    headers ??= {};
    headers.addAll(headers);
    return _client.readBytes(url, headers: headers);
  }
}
