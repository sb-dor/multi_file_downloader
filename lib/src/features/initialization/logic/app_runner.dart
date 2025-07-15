import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/common/utils/reusable_functions.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/logic/dependencies_composition.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/logic/desktop_initializer.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/logic/factories/app_logger_factory.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/application_config.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/widgets/io_material_context.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/widgets/web_material_context.dart';
import 'package:logger/logger.dart';

class AppRunner {
  Future<void> initialize() async {
    HttpOverrides.global = MyHttpOverrides();

    final logger =
        AppLoggerFactory(logFilter: kReleaseMode ? NoOpLogFilter() : DevelopmentFilter()).create();
    //
    await runZonedGuarded(
      () async {
        final binding = WidgetsFlutterBinding.ensureInitialized();

        binding.deferFirstFrame();

        if (!kIsWeb && !kIsWasm && ReusableFunctions.instance.isDesktop) {
          await DesktopInitializer().run();
        }

        FlutterError.onError = (errorDetails) {
          logger.log(Level.error, errorDetails);
          // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          logger.log(Level.error, "error $error | stacktrace: $stack");
          // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };

        try {
          final applicationConfig = ApplicationConfig();
          final dependencyComposition =
              await DependencyComposition(
                logger: logger,
                applicationConfig: applicationConfig,
              ).create();

          late final Widget materialContext;

          if (kIsWeb || kIsWasm) {
            materialContext = WebMaterialContext(dependencyContainer: dependencyComposition);
          } else {
            materialContext = IoMaterialContext(dependencyContainer: dependencyComposition);
          }

          runApp(materialContext);
        } catch (error) {
          rethrow;
        } finally {
          binding.allowFirstFrame();
        }
      },
      (error, stackTrace) {
        logger.log(Level.debug, "Error: $error | stacktrace: $stackTrace");
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
