import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dispensary/services/database_service.dart';

class BackupService {
  Future<String> getdbPath() async {
    var documentsDirectory = await getDatabasesPath();
    String dbPath = join(documentsDirectory, DatabaseService.getDatabaseName());
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
      final backupPath =
          join(databaseFile.parent.path, '${basenameWithoutExtension(databaseFile.path)}_bk.db');
      debugPrint('Creating a backup on given location');
      debugPrint(backupPath);
      // Read database file
      List<int> fileBytes = await databaseFile.readAsBytes();

      final backup = File(backupPath);

      // Write database content to backup file
      await backup.writeAsBytes(fileBytes);

      debugPrint('A backup is written successfully.');
      return backup;
    } catch (e) {
      debugPrint('Error creating database backup: $e');
      return null;
    }
  }

  // Function to upload the database backup file to Google Drive
  Future<void> _uploadDatabaseBackupToDrive(
      drive.DriveApi driveApi, File backupFile, String folderId) async {
    debugPrint("Upload backup to Google Drive");
    try {
      debugPrint("Reading backup...");
      List<int> fileBytes = await backupFile.readAsBytes();
      debugPrint("Set up media stream");
      final mediaStream = Stream<List<int>>.fromIterable([fileBytes]);
      debugPrint("Set up File info such as name, modifiedTime and folder id");
      final driveFile = drive.File();
      driveFile.name = basename(backupFile.path);
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = [folderId];
      debugPrint("Upload started....");
      final media = drive.Media(mediaStream, fileBytes.length);
      final response = await driveApi.files.create(driveFile, uploadMedia: media);
      debugPrint('Backup uploaded successfully with response name as ${response.name}');
    } catch (e) {
      debugPrint('Failed during read or uploading backup to drive');
      debugPrint(e.toString());
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

  Future<void> uploadBackup(GoogleSignInAccount account) async {
    try {
      debugPrint("Creating drive api...");
      final driveApi = await _getDriveApi(account);
      if (driveApi == null) {
        return;
      }

      // db path
      var documentsDirectory = await getDatabasesPath();
      String dbPath = join(documentsDirectory, DatabaseService.getDatabaseName());
      final databaseFile = File(dbPath);
      debugPrint("Createing backup in memory...");
      File? backup = await _createDatabaseBackup(databaseFile);

      if (backup != null) {
        debugPrint("Backup location ${backup.path}");
        await _uploadDatabaseBackupToDrive(driveApi, backup, 'appDataFolder');
      } else {
        debugPrint('Createing backup in memory failed');
      }
    } finally {
      debugPrint('Upload Service Completed');
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
      return;
    }
    await driveApi.files.delete(fileId);
  }

  Future<void> applyBackup(
      GoogleSignInAccount account, String fileId, int totalBytes, Function updateProgress) async {
    var documentsDirectory = await getDatabasesPath();
    String databasepath = join(documentsDirectory, DatabaseService.getDatabaseName());

    final localDriveApi = await _getDriveApi(account);
    if (localDriveApi == null) {
      return;
    }

    drive.Media res = await localDriveApi.files
        .get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    debugPrint('Initialize total bytes downloaded');
    int totalDownloaded = 0;
    debugPrint('Open a file for writing');
    final file = File(databasepath);
    final fileSink = file.openWrite();
    debugPrint('Listen to the stream and process chunks of data');
    await for (final chunk in res.stream) {
      debugPrint('Write chunk to file');
      fileSink.add(chunk);
      totalDownloaded += chunk.length;
      double downloadedPrec = calculateDownloadPercentage(totalBytes, totalDownloaded);
      updateProgress(downloadedPrec);
      //debugPrint('Downloaded $totalDownloaded bytes, downloadedPrec-$downloadedPrec');
    }

    debugPrint('Close the file sink');
    await fileSink.close();
    debugPrint('Backup restored successfully.');
  }
}

double calculateDownloadPercentage(int totalBytes, int downloadedBytes) {
  if (totalBytes == 0) {
    return 0.0;
  }
  // Calculate the percentage
  double percentage = (downloadedBytes / totalBytes) * 100;
  return percentage;
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
