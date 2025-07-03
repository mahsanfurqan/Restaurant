import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  const ThemeLocalDataSource(this._secureStorage);

  Future<bool> saveThemeMode(String themeMode) async {
    try {
      final key = AppConstants.secureStorageKeys.themeMode;
      await _secureStorage.write(key: key, value: themeMode);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<ThemeMode?> getSavedThemeMode() async {
    final key = AppConstants.secureStorageKeys.themeMode;
    final themeMode = await _secureStorage.read(key: key);
    return (themeMode != null)
        ? ThemeMode.values.firstWhere((e) => e.name == themeMode)
        : null;
  }
}
