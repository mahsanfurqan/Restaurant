import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/theme/data/data_source/local/theme_local_data_source.dart';

class ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  const ThemeRepository(this.localDataSource);

  Future<bool> saveThemeMode(String themeMode) =>
      localDataSource.saveThemeMode(themeMode);

  Future<ThemeMode?> getSavedThemeMode() => localDataSource.getSavedThemeMode();
}
