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
    return Scaffold();
  }
}
