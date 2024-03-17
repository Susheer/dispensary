// search_screen.dart
import 'dart:math';

import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/common/typography.dart';
import 'package:dispensary/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ManageBackup extends StatefulWidget {
  static const String path = "/manage-backup";
  @override
  State<ManageBackup> createState() => _ManageBackupState();
}

class _ManageBackupState extends State<ManageBackup> {
  late List<drive.File> driveFiles = [];

  Future<void> onLoad() async {
    var fileList = await Provider.of<AuthProvider>(context, listen: false).showBackups();

    if (fileList == null) {
      return;
    }

    if (fileList.files == null) {
      return;
    }

    setState(() {
      driveFiles = fileList.files!;
    });
  }

  Future<void> onDelete(String fileId) async {
    await Provider.of<AuthProvider>(context, listen: false).blockScreen(context);
    await Provider.of<AuthProvider>(context, listen: false).deleteFile(fileId);
    await Provider.of<AuthProvider>(context, listen: false).unblockScreen(context);
  }

  Future<void> onClear() async {
    setState(() {
      driveFiles = [];
    });
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageHeaderContainer(context),
            Expanded(
                child: ListView.builder(
              itemCount: driveFiles.length,
              itemBuilder: (context, index) {
                drive.File file = driveFiles[index];
                return BackupResult(
                  file: file,
                  onLoad: onLoad,
                  onDelete: onDelete,
                  onClear: onClear,
                );
              },
            )),
            createBackup(context),
          ],
        ));
  }

  Container createBackup(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width * 80 / 100, 53)),
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false).createBackup(context);
                  await onLoad();
                },
                child: const Text('Create New Backup'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container pageHeaderContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Backups: ${driveFiles.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () async {
                    onClear();
                    onLoad();
                  },
                  child: const Text('Refresh'))
            ],
          ),
        ],
      ),
    );
  }
}

class BackupResult extends StatelessWidget {
  const BackupResult(
      {super.key,
      required this.file,
      required this.onLoad,
      required this.onDelete,
      required this.onClear});

  final drive.File file;
  final Function onLoad;
  final Function onClear;
  final Function(String fileId) onDelete;
  String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 12,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.only(top: 17, left: 25, right: 25),
        child: Column(
          children: [
            Typography2(label: 'Name', value: file.name ?? "no-name"),
            RowWithLabelAndValueSet(
                label1: 'Size: ',
                value1: getFileSizeString(bytes: int.parse(file.size!), decimals: 2).toString(),
                label2: 'Version:',
                value2: file.version ?? "no-version"),
            Typography2(label: 'Created Time ', value: timeago.format(file.createdTime!)),
            const Separator(),
            buildActionButtonsRow(context, file)
          ],
        ),
      ),
    );
  }

  Widget buildActionButtonsRow(BuildContext context, drive.File file) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextButton(
        child: const Text('Apply this backup'),
        onPressed: () {},
      ),
      TextButton(
        child: const Text('Delete this backup'),
        onPressed: () async {
          await onDelete(file.id!);
          await onLoad();
        },
      ),
    ]);
  }
}
