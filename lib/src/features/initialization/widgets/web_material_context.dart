import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/dependency_container.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/widgets/multi_file_download_config_widget.dart';

class WebMaterialContext extends StatefulWidget {
  const WebMaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<WebMaterialContext> createState() => _WebMaterialContextState();
}

class _WebMaterialContextState extends State<WebMaterialContext> {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return DependenciesScope(
      dependencies: widget.dependencyContainer,
      child: MaterialApp(
        debugShowCheckedModeBanner: !kReleaseMode,
        builder:
            (context, child) => MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: TextScaler.linear(mediaQueryData.textScaler.scale(1).clamp(0.5, 2)),
              ),
              child: child!,
            ),
        home: MultiFileDownloadConfigWidget(),
      ),
    );
  }
}
