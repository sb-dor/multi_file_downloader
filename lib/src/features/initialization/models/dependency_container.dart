import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client_base.dart';
import 'package:logger/logger.dart';

class DependencyContainer {
  DependencyContainer({required this.restClientBase, required this.logger});

  final Logger logger;

  final RestClientBase restClientBase;
}
