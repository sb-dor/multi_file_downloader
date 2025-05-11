import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client_base.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/logic/dependencies_composition.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/controller/multi_file_downloader_controller.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/helpers/multi_file_downloader_helper.dart';

class MultiFileDownloaderControllerFactory extends Factory<MultiFileDownloaderController> {
  MultiFileDownloaderControllerFactory(this.restClientBase);

  final RestClientBase restClientBase;
  @override
  MultiFileDownloaderController create() {
    final multifileDownloaderHelper = MultiFileDownloaderHelper();
    return MultiFileDownloaderController(restClientBase, multifileDownloaderHelper);
  }
}
