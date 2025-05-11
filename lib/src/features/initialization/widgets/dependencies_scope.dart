import 'package:flutter/material.dart';
import 'package:flutter_multi_file_downloader/src/features/initialization/models/dependency_container.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({super.key, required super.child, required this.dependencies});

  static DependencyContainer of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final scope = context.dependOnInheritedWidgetOfExactType<DependenciesScope>();
      assert(scope != null, "No DependenciesScope found in context");
      return scope!.dependencies;
    } else {
      final scope = context.getElementForInheritedWidgetOfExactType<DependenciesScope>()?.widget;
      final checkScope = scope is DependenciesScope;
      assert(checkScope, "No DependenciesScope found in context");
      return (scope as DependenciesScope).dependencies;
    }
  }

  final DependencyContainer dependencies;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
