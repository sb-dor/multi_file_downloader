import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/logic/factories/multi_file_downloader_controller_factory.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/controller/multi_file_downloader_controller.dart';
import 'package:flutter_multi_file_downloader/src/features/multi_file_download/widgets/widgets/file_downloader_widget.dart';

part "multi_file_download_widget.dart";

class MultiFileDownloadConfigInhWidget extends InheritedWidget {
  const MultiFileDownloadConfigInhWidget({
    super.key,
    required this.multiFileDownloadConfigWidgetState,
    required super.child,
  });

  static MultiFileDownloadConfigWidgetState of(BuildContext context, {bool listen = false}) =>
      listen
          ? context
              .dependOnInheritedWidgetOfExactType<MultiFileDownloadConfigInhWidget>()!
              .multiFileDownloadConfigWidgetState
          : context
              .getInheritedWidgetOfExactType<MultiFileDownloadConfigInhWidget>()!
              .multiFileDownloadConfigWidgetState;

  final MultiFileDownloadConfigWidgetState multiFileDownloadConfigWidgetState;

  @override
  bool updateShouldNotify(covariant MultiFileDownloadConfigInhWidget oldWidget) {
    return oldWidget.multiFileDownloadConfigWidgetState != multiFileDownloadConfigWidgetState;
  }
}

class MultiFileDownloadConfigWidget extends StatefulWidget {
  const MultiFileDownloadConfigWidget({super.key});

  @override
  State<MultiFileDownloadConfigWidget> createState() => MultiFileDownloadConfigWidgetState();
}

class MultiFileDownloadConfigWidgetState extends State<MultiFileDownloadConfigWidget> {
  late final MultiFileDownloaderController multiFileDownloaderController;

  @override
  void initState() {
    final dependencies = DependenciesScope.of(context, listen: false);
    multiFileDownloaderController =
        MultiFileDownloaderControllerFactory(dependencies.restClientBase).create();
    super.initState();
  }

  @override
  void dispose() {
    multiFileDownloaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiFileDownloadConfigInhWidget(
      multiFileDownloadConfigWidgetState: this,
      child: MultiFileDownloadWidget(),
    );
  }
}
