part of "multi_file_downloader_controller.dart";

class FileDownloader with ChangeNotifier {
  FileDownloader({required this.url, required this.directory, required this.restClientBase});

  final String url;
  final Directory directory;
  final RestClientBase restClientBase;

  double? downloadedBytes;
  double? totalBytes;
  DownloadMessageType? message;
  Object? lastError;

  final ValueNotifier<double> progress = ValueNotifier(0.0);

  StreamSubscription<List<int>>? _subscription;

  Future<void> download({bool openFile = false}) async {
    try {
      final uri = Uri.parse(url);
      final filePath = '${directory.path}/${uri.pathSegments.last}';
      final file = File(filePath);

      if (await file.exists()) {
        message = DownloadMessageType.success;
        notifyListeners();
        if (openFile) await _openFile(filePath);
        return;
      }

      message = DownloadMessageType.downloading;
      downloadedBytes = 0.0;
      notifyListeners();

      final response = await restClientBase.sendAndGetStream(path: url, method: RequestType.get);
      totalBytes = response.contentLength?.toDouble() ?? 0;
      final sink = file.openWrite();
      final completer = Completer<void>();

      _subscription = response.stream.listen(
        (chunk) {
          downloadedBytes = (downloadedBytes ?? 0) + chunk.length;
          sink.add(chunk);
          if (totalBytes != null && totalBytes! > 0) {
            progress.value = downloadedBytes! / totalBytes!;
          }
          notifyListeners();
        },
        onDone: () async {
          await sink.close();
          message = DownloadMessageType.success;
          notifyListeners();
          completer.complete();
        },
        onError: (error, stackTrace) async {
          await sink.close();
          lastError = error;
          message = DownloadMessageType.error;
          notifyListeners();
          completer.completeError(error, stackTrace);
        },
        cancelOnError: true,
      );

      await completer.future;
      if (openFile && message == DownloadMessageType.success) {
        await _openFile(filePath);
      }
    } catch (error, stackTrace) {
      lastError = error;
      message = DownloadMessageType.error;
      notifyListeners();
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void cancel() async {
    await _subscription?.cancel();
    message = DownloadMessageType.canceled;
    notifyListeners();
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
    progress.dispose();
    super.dispose();
  }
}
