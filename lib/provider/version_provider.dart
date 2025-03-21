import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionProvider extends ChangeNotifier {
  String _version = "Loading...";

  String get version => _version;

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    notifyListeners();
  }
}
