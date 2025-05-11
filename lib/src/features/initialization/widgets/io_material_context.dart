import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/dependency_container.dart';

class IoMaterialContext extends StatefulWidget {
  const IoMaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<IoMaterialContext> createState() => _IoMaterialContextState();
}

class _IoMaterialContextState extends State<IoMaterialContext> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
