import 'package:flutter_multi_file_downloader/src/common/utils/reusable_functions.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/logic/dependencies_composition.dart';
import 'package:logger/logger.dart';

class AppLoggerFactory extends Factory<Logger> {
  //
  AppLoggerFactory({required LogFilter logFilter}) : _logFilter = logFilter;

  final LogFilter _logFilter;

  @override
  Logger create() {
    return Logger(
      filter: _logFilter,
      printer: PrettyPrinter(
        methodCount: 2,
        // Number of method calls to be displayed
        errorMethodCount: 8,
        // Number of method calls if stacktrace is provided
        lineLength: 120,

        colors: ReusableFunctions.instance.isMacOsOriOS ? false : true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        // Should each log print contain a timestamp
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      output: ConsoleOutput(),
    );
  }
}

final class NoOpLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}
