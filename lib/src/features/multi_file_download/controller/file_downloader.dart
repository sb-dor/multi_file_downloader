import 'dart:async' show StreamSubscription, Completer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client_base.dart';
import 'package:flutter_multi_file_downloader/src/common/utils/reusable_functions.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/enums/download_message_type.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/models/download_state.dart';
import 'package:open_file/open_file.dart';

class FileDownloader with ChangeNotifier {
  FileDownloader({
    required this.url,
    required this.directory,
    required this.restClientBase,
    DownloadState? downloadState,
  }) : downloadProgress = ValueNotifier(
         downloadState ??
             DownloadState(progress: 0.0, message: DownloadMessageType.idle),
       );

  final String url;
  final Directory directory;
  final RestClientBase restClientBase;

  final ValueNotifier<DownloadState> downloadProgress;

  StreamSubscription<List<int>>? _subscription;

  Future<void> download({bool openFile = false}) async {
    try {
      final file = await getFile();

      if (await file.exists()) {
        _updateState(DownloadMessageType.success, 1.0);
        if (openFile) await _openFile(file.path);
        return;
      }

      _updateState(DownloadMessageType.downloading, 0.0);

      final response = await restClientBase.sendAndGetStream(
        path: url,
        method: RequestType.get,
      );
      print("Status: ${response.statusCode} - ${response.contentLength} ");
      final total = response.contentLength?.toDouble() ?? 0;
      double downloaded = 0.0;
      final sink = file.openWrite();
      final completer = Completer<void>();

      _subscription = response.stream.listen(
        (chunk) {
          downloaded += chunk.length;
          sink.add(chunk);
          final progress = (total > 0) ? downloaded / total : 0.0;
          _updateState(DownloadMessageType.downloading, progress);
        },
        onDone: () async {
          await sink.close();
          _updateState(DownloadMessageType.success, 1.0);
          completer.complete();
        },
        onError: (error, stackTrace) async {
          await sink.close();
          await cancel();
          _updateState(DownloadMessageType.error, 0.0, error: error);
          completer.completeError(error, stackTrace);
        },
        cancelOnError: true,
      );

      await completer.future;
      if (openFile && downloadProgress.value.isComplete) {
        await _openFile(file.path);
      }
    } catch (error, stackTrace) {
      _updateState(DownloadMessageType.error, 0.0, error: error);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _updateState(
    DownloadMessageType type,
    double progress, {
    Object? error,
  }) {
    downloadProgress.value = DownloadState(
      progress: progress,
      message: type,
      error: error,
    );
    notifyListeners();
  }

  Future<void> cancel() async {
    await _subscription?.cancel();
    final file = await getFile();
    if (file.existsSync()) file.deleteSync();
    _updateState(DownloadMessageType.canceled, 0.0);
  }

  Future<File> getFile() async {
    final uri = Uri.parse(url);
    final filePath =
        '${directory.path}/${ReusableFunctions.instance.removeSpaceFromStringForDownloadingFile(uri.path)}.jpg';
    print("file path: $filePath");
    return File(filePath);
  }

  // TODO: show notification that file was not opened
  // if something goes wrong
  Future<void> _openFile(String path) async {
    final result = await OpenFile.open(path);
    switch (result.type) {
      case ResultType.fileNotFound:
      case ResultType.noAppToOpen:
      case ResultType.permissionDenied:
      case ResultType.error:
        break;
      case _:
        break;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    downloadProgress.dispose();
    super.dispose();
  }
}
