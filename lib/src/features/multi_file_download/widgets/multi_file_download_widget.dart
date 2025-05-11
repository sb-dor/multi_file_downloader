part of "multi_file_download_config_widget.dart";

class MultiFileDownloadWidget extends StatefulWidget {
  const MultiFileDownloadWidget({super.key});

  @override
  State<MultiFileDownloadWidget> createState() => _MultiFileDownloadWidgetState();
}

class _MultiFileDownloadWidgetState extends State<MultiFileDownloadWidget> {
  late final MultiFileDownloaderController _multiFileDownloaderController;

  @override
  void initState() {
    super.initState();
    _multiFileDownloaderController =
        MultifileDownloadCondigInhWidget.of(context).multiFileDownloaderController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Multi file downloader")),
      body: ListenableBuilder(
        listenable: _multiFileDownloaderController,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: mediaUrls.length,
                itemBuilder: (context, index) {
                  final url = mediaUrls[index];
                  return FileDownloaderWidget(url: url);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
