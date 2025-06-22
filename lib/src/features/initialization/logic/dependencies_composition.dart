import 'package:flutter_multi_file_downloader/src/common/http_rest_client/http/rest_client_http.dart';
import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client_base.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/application_config.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/dependency_container.dart';
import 'package:logger/logger.dart';

final class DependencyComposition extends AsyncFactory<DependencyContainer> {
  DependencyComposition({required this.logger, required this.applicationConfig});

  final Logger logger;
  final ApplicationConfig applicationConfig;

  @override
  Future<DependencyContainer> create() async {
    final RestClientBase restClientBase = RestClientHttp(
      baseUrl: applicationConfig.mainUrl,
      logger: logger,
    );

    return DependencyContainer(
      restClientBase: restClientBase,
      logger: logger,
      applicationConfig: applicationConfig,
    );
  }
}

abstract class Factory<T> {
  T create();
}

abstract class AsyncFactory<T> {
  Future<T> create();
}
