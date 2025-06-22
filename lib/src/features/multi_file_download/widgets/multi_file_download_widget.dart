part of "multi_file_download_config_widget.dart";

class MultiFileDownloadWidget extends StatefulWidget {
  const MultiFileDownloadWidget({super.key});

  @override
  State<MultiFileDownloadWidget> createState() =>
      _MultiFileDownloadWidgetState();
}

class _MultiFileDownloadWidgetState extends State<MultiFileDownloadWidget> {
  late final MultiFileDownloaderController _multiFileDownloaderController;

  final List<String> _mediaUrls = [];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _multiFileDownloaderController =
        MultifileDownloadConfigInhWidget.of(
          context,
        ).multiFileDownloaderController;

    for (int i = 0; i < 10; i++) {
      _mediaUrls.add(_randomPictureUrl());
    }
  }

  String _randomPictureUrl({int width = 1920, int height = 1080}) {
    final int randomInt = _random.nextInt(1000);
    // you can remove last parameter
    // it's just for uniqueness
    return '/seed/$randomInt/$width/$height';
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
                itemCount: _mediaUrls.length,
                itemBuilder: (context, index) {
                  final url = _mediaUrls[index];
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
