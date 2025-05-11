import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/dependency_container.dart';

class WebMaterialContext extends StatefulWidget {
  const WebMaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<WebMaterialContext> createState() => _WebMaterialContextState();
}

class _WebMaterialContextState extends State<WebMaterialContext> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
