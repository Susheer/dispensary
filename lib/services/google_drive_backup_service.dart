import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/common/show_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GoogleDriveTest extends StatefulWidget {
  @override
  _GoogleDriveTest createState() => _GoogleDriveTest();
}

class _GoogleDriveTest extends State<GoogleDriveTest> {
  bool _loginStatus = false;
  late BuildContext ctx;
  final String folderId = "appDataFolder";
  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  @override
  void initState() {
    _loginStatus = googleSignIn.currentUser != null;
    super.initState();
  }

  Future<String> getdbPath() async {
    var documentsDirectory = await getDatabasesPath();
    String dbPath = join(documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database.db');
    return dbPath;
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Google Drive Test"),
        ),
        body: _createBody(context),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    final signIn = ElevatedButton(
      onPressed: () {
        _signIn();
      },
      child: Text("Sing in"),
    );
    final signOut = ElevatedButton(
      onPressed: () {
        _signOut();
      },
      child: Text("Sing out"),
    );
    final uploadToHidden = ElevatedButton(
      onPressed: () {
        _uploadToHidden();
      },
      child: Text("Upload to app folder (hidden)"),
    );
    final showList = ElevatedButton(
      onPressed: () {
        _showList();
      },
      child: Text("Show the data list"),
    );

    return Column(
      children: [
        Center(child: Text("Sign in status: ${_loginStatus ? "In" : "Out"}")),
        Center(child: signIn),
        Center(child: signOut),
        Divider(),
        Center(child: uploadToHidden),
        Center(child: showList),
      ],
    );
  }

  Future<void> _signIn() async {
    final googleUser = await googleSignIn.signIn();

    try {
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        print("Sign in");
        setState(() {
          _loginStatus = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signOut() async {
    await googleSignIn.signOut();
    setState(() {
      _loginStatus = false;
    });
    print("Sign out");
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      await showMessage(ctx, "Sign-in first", "Error");
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

// Function to create a backup of the SQLite database file
  Future<File?> createDatabaseBackup(File databaseFile) async {
    try {
      // Read database file
      List<int> fileBytes = await databaseFile.readAsBytes();

      // Create backup file
      final backupFileName = "${basenameWithoutExtension(databaseFile.path)}_backup.db";
      final backupFile = File("${databaseFile.parent.path}/$backupFileName");

      // Write database content to backup file
      await backupFile.writeAsBytes(fileBytes);

      print('Database backup created successfully: ${backupFile.path}');
      return backupFile;
    } catch (e) {
      print('Error creating database backup: $e');
      return null;
    }
  }

  // Function to upload the database backup file to Google Drive
  Future<void> uploadDatabaseBackupToDrive(
      drive.DriveApi driveApi, File backupFile, String folderId) async {
    try {
      print("uploadDatabaseBackupToDrive Invoked");
      // Read backup file
      List<int> fileBytes = await backupFile.readAsBytes();
      // Set up media stream
      final mediaStream = Stream<List<int>>.fromIterable([fileBytes]);

      // Set up File info
      final driveFile = drive.File();
      final timestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      driveFile.name = basename(backupFile.path); // Use backup file name
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = [folderId]; // Assuming folderId is defined elsewhere

      // Upload
      final media = drive.Media(mediaStream, fileBytes.length);
      final response = await driveApi.files.create(driveFile, uploadMedia: media);
      print('Database backup uploaded successfully: ${response.name}');
    } catch (e) {
      print('Error uploading database backup: $e');
    }
  }

  Future<void> _uploadToHidden() async {
    print("_uploadToHidden Invoked");
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }
      print("driveApi created");
      // Not allow a user to do something else
      showGeneralDialog(
        context: ctx,
        barrierDismissible: false,
        transitionDuration: Duration(seconds: 2),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // db path
      var documentsDirectory = await getDatabasesPath();
      String dbPath = join(documentsDirectory, dotenv.env['DB_PATH'] ?? 'default_database.db');
      debugPrint("[Database Path] $dbPath");
      final databaseFile = File(dbPath);
      // createDb backup
      File? backupFile = await createDatabaseBackup(databaseFile);

      if (backupFile != null) {
        // Upload backup to Google Drive
        debugPrint("[Backup database path] ${backupFile.path}");
        await uploadDatabaseBackupToDrive(driveApi, backupFile, folderId);
      } else {
        print('Database backup creation failed. Upload aborted.');
      }
      // simulate a slow process
      await Future.delayed(Duration(seconds: 2));
    } finally {
      // Remove a dialog
      Navigator.pop(ctx);
    }
  }

  Future<void> _showList() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id, name, modifiedTime)',
    );
    final files = fileList.files;
    if (files == null) {
      return showMessage(ctx, "Data not found", "");
    }

    final alert = AlertDialog(
      title: Text("Item List"),
      content: SingleChildScrollView(
        child: ListBody(
          children: files.map((e) => Text(e.name ?? "no-name")).toList(),
        ),
      ),
    );

    return showDialog(
      context: ctx,
      builder: (BuildContext context) => alert,
    );
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
