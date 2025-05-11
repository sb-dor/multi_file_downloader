import 'package:flutter_multi_file_downloader/src/features/initialization/models/environment.dart';

class ApplicationConfig {
  const ApplicationConfig();

  // for checking type of environment
  Environment get environment {
    final env = const String.fromEnvironment("ENVIRONMENT").trim();

    return Environment.from(env);
  }

  String get mainUrl => const String.fromEnvironment("MAIN_URL");
}
