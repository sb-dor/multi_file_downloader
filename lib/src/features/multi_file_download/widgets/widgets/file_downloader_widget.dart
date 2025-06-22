import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/controller/file_downloader.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/controller/multi_file_downloader_controller.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/enums/download_message_type.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/widgets/multi_file_download_config_widget.dart';

class FileDownloaderWidget extends StatefulWidget {
  const FileDownloaderWidget({super.key, required this.url});

  final String url;

  @override
  State<FileDownloaderWidget> createState() => _FileDownloaderWidgetState();
}

class _FileDownloaderWidgetState extends State<FileDownloaderWidget> {
  FileDownloader? _fileDownloader;
  late final MultiFileDownloaderController _multiFileDownloaderController;
  late final String _mainUrl;

  bool isVideo(String url) => url.endsWith('.mp4');

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _mainUrl = dependencies.applicationConfig.mainUrl;
    _multiFileDownloaderController =
        MultiFileDownloadConfigInhWidget.of(context).multiFileDownloaderController;
    _fileDownloader = _multiFileDownloaderController.getFileDownloaderIfItExist(widget.url);
  }

  void _download() async {
    _fileDownloader = await _multiFileDownloaderController.download(widget.url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading:
            isVideo(widget.url)
                ? const Icon(Icons.videocam, size: 40)
                : Image.network("$_mainUrl${widget.url}", width: 60, height: 60, fit: BoxFit.cover),
        title: Text("$_mainUrl${widget.url}".split('/').last, overflow: TextOverflow.ellipsis),
        trailing:
            _fileDownloader == null
                ? IconButton(icon: const Icon(Icons.download), onPressed: _download)
                : ListenableBuilder(
                  listenable: _fileDownloader!,
                  builder: (context, child) {
                    return SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_fileDownloader?.downloadProgress.value.message ==
                              DownloadMessageType.downloading)
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                final bool cancel = _multiFileDownloaderController.cancelDownload(
                                  widget.url,
                                );
                                if (cancel) {
                                  setState(() {
                                    _fileDownloader = null;
                                  });
                                }
                              },
                            ),
                          switch (_fileDownloader?.downloadProgress.value.message) {
                            DownloadMessageType.downloading => Center(
                              child: CircularProgressIndicator(
                                value: _fileDownloader?.downloadProgress.value.progress,
                                color: Colors.purple,
                              ),
                            ),
                            DownloadMessageType.success ||
                            DownloadMessageType.error ||
                            DownloadMessageType.canceled ||
                            _ => IconButton(onPressed: _download, icon: const Icon(Icons.download)),
                          },
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
