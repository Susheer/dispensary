// search_screen.dart
import 'package:dispensary/common/seperator.dart';
import 'package:dispensary/common/typography.dart';
import 'package:dispensary/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:provider/provider.dart';

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
                return BackupResult(file: file);
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
  const BackupResult({
    super.key,
    required this.file,
  });

  final drive.File file;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
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
          padding: const EdgeInsets.only(top: 17, bottom: 35, left: 25, right: 25),
          child: Column(
            children: [
              Typography2(label: 'Name', value: file.name ?? "no-name"),
              RowWithLabelAndValueSet(
                  label1: 'Gender ', label2: 'Mob ', value1: "sdsdw", value2: "wewew"),
              const Separator(),
              Typography2(label: 'Gurdian Name ', value: "wdqwd" ?? ""),
              Typography2(label: 'Address ', value: "dwqdwq" ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
