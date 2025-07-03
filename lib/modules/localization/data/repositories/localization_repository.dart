import 'dart:ui';

import 'package:flutter_boilerplate/modules/localization/data/data_sources/local/localization_local_data_source.dart';

class LocalizationRepository {
  final LocalizationLocalDataSource _localDataSource;

  LocalizationRepository(this._localDataSource);

  Future<bool> saveLocale(String locale) => _localDataSource.saveLocale(locale);

  Future<Locale?> getSavedLocale() => _localDataSource.getSavedLocale();
}
