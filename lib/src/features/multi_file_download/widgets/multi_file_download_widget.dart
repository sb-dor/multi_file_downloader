part of "multi_file_download_config_widget.dart";

class MultiFileDownloadWidget extends StatefulWidget {
  const MultiFileDownloadWidget({super.key});

  @override
  State<MultiFileDownloadWidget> createState() => _MultiFileDownloadWidgetState();
}

class _MultiFileDownloadWidgetState extends State<MultiFileDownloadWidget> {
  late final MultiFileDownloaderController _multiFileDownloaderController;

  late final List<String> mediaUrls;

  @override
  void initState() {
    super.initState();
    _multiFileDownloaderController =
        MultifileDownloadConfigInhWidget.of(context).multiFileDownloaderController;

    mediaUrls = [
      '/id/1/1920/1010.jpg',
      '/id/2/1920/1010.jpg',
      '/id/3/1920/1010.jpg',
      '/id/4/1920/1010.jpg',
      '/id/5/1920/1010.jpg',
      '/id/5/1920/1010.jpg',
      '/id/6/1920/1010.jpg',
      '/id/7/1920/1010.jpg',
    ];
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
