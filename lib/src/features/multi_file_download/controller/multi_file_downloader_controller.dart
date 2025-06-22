import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client_base.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/enums/download_message_type.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/helpers/multi_file_downloader_helper.dart';
import 'package:open_file/open_file.dart';

import 'file_downloader.dart';

class MultiFileDownloaderController with ChangeNotifier {
  MultiFileDownloaderController(
    this.restClientBase,
    this.multiFileDownloaderHelper,
  );

  final RestClientBase restClientBase;
  final MultiFileDownloaderHelper multiFileDownloaderHelper;
  final Map<String, FileDownloader> _downloads = {};

  Map<String, FileDownloader> get downloads => _downloads;

  Future<FileDownloader?> download(String url, {bool openFile = false}) async {
    final storagePer = await multiFileDownloaderHelper.storagePermission();
    if (!storagePer || _downloads.containsKey(url)) return null;

    final downloader = FileDownloader(
      url: url,
      directory: await multiFileDownloaderHelper.downloadsDirectory(),
      restClientBase: restClientBase,
    );

    // TODO: show notification if something goes wrong
    downloader.addListener(() {
      if (downloader.downloadProgress.value.message ==
          DownloadMessageType.downloading)
        return;
      _removeDownloaderIfItExists(downloader);
    });

    downloader.download(openFile: openFile);
    _downloads[downloader.url] = downloader;
    notifyListeners();
    return downloader;
  }

  void _removeDownloaderIfItExists(FileDownloader downloader) {
    _downloads.remove(downloader.url);
    notifyListeners();
  }

  bool cancelDownload(String url) {
    final downloader = _downloads[url];
    if (downloader != null) {
      downloader.cancel();
    }
    return true;
  }

  FileDownloader? getFileDownloaderIfItExist(String url) {
    if (downloads[url] == null) return null;
    return downloads[url];
  }

  @override
  void dispose() {
    for (final downloader in _downloads.values) {
      downloader.dispose();
    }
    super.dispose();
  }
}
