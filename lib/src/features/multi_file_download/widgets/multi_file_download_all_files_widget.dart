import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/helpers/multi_file_downloader_helper.dart';

class MultiFileDownloadAllFilesWidget extends StatefulWidget {
  const MultiFileDownloadAllFilesWidget({super.key});

  @override
  State<MultiFileDownloadAllFilesWidget> createState() => _MultiFileDownloadAllFilesWidgetState();
}

class _MultiFileDownloadAllFilesWidgetState extends State<MultiFileDownloadAllFilesWidget> {
  final _multiFileDownloaderHelper = MultiFileDownloaderHelper();

  List<File> _files = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      _isLoading = true;
      setState(() {});
      final dir = await _multiFileDownloaderHelper.downloadsDirectory();
      final allItems = dir.listSync(recursive: true);
      final files =
          allItems
              // get all types where type are FileSystemEntity
              .whereType<FileSystemEntity>()
              // checks whether it's file (not directory or link )
              .where((entity) => FileSystemEntity.isFileSync(entity.path))
              // creates from them Files
              .map((e) => File(e.path))
              .toList();

      setState(() {
        _files = files;
        _isLoading = false;
      });
    } on Object catch (error, stackTrace) {
      setState(() => _isLoading = false);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloaded Files')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _files.isEmpty
              ? const Center(child: Text('No files found'))
              : ListView.builder(
                itemCount: _files.length,
                itemBuilder: (context, index) {
                  final file = _files[index];
                  final filename = file.path.split('/').last;
                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(filename),
                    subtitle: Text(file.path),
                    onTap: () {
                      // handle file tap, e.g., open it
                    },
                  );
                },
              ),
    );
  }
}
