import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client_base.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/application_config.dart';
import 'package:logger/logger.dart';

class DependencyContainer {
  DependencyContainer({
    required this.restClientBase,
    required this.logger,
    required this.applicationConfig,
  });

  final Logger logger;

  final RestClientBase restClientBase;

  final ApplicationConfig applicationConfig;
}
