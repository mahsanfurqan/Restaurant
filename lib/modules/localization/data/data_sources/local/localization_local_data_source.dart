import 'dart:ui';

import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalizationLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  const LocalizationLocalDataSource(this._secureStorage);

  Future<bool> saveLocale(String locale) async {
    try {
      final key = AppConstants.secureStorageKeys.locale;
      await _secureStorage.write(key: key, value: locale);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Locale?> getSavedLocale() async {
    final key = AppConstants.secureStorageKeys.locale;
    final locale = await _secureStorage.read(key: key);

    if (locale == null) return null;
    return Locale(locale);
  }
}
