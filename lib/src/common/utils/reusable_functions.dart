import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class ReusableFunctions {
  static ReusableFunctions? _instance;

  static ReusableFunctions get instance => _instance ??= ReusableFunctions._();

  ReusableFunctions._();

  bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows;

  bool get isMacOsOriOS => switch (defaultTargetPlatform) {
    TargetPlatform.iOS => true,
    TargetPlatform.macOS => true,
    _ => false,
  };

  void showSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String removeSpaceFromStringForDownloadingFile(String value) {
    String res = '';
    for (int i = 0; i < value.length; i++) {
      if (value[i] == ' ' || value[i] == '.') continue;
      if (value[i] == '-' ||
          value[i] == ":" ||
          value[i] == "\"" ||
          value[i] == "'" ||
          value[i] == ',' ||
          value[i] == '/' ||
          value[i] == "\\" ||
          value[i] == '@' ||
          value[i] == '!' ||
          value[i] == '\$' ||
          value[i] == '%' ||
          value[i] == '^' ||
          value[i] == '&' ||
          value[i] == '*' ||
          value[i] == '(' ||
          value[i] == ')' ||
          value[i] == '|' ||
          value[i] == '?') {
        res += '_';
        continue;
      }
      res += value[i];
    }
    if (res.startsWith('_')) {
      res = res.substring(1);
    }
    if (res.endsWith('_')) {
      res = res.substring(0, res.length - 1);
    }
    return res;
  }
}
