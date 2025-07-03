import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/theme/data/data_source/local/theme_local_data_source.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late ThemeLocalDataSource dataSource;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    dataSource = ThemeLocalDataSource(
      mockFlutterSecureStorage,
    );
  });

  final themeModeKey = AppConstants.secureStorageKeys.themeMode;
  final testThemeMode = ThemeMode.dark.name;

  group('saveThemeMode', () {
    test('should return true when save theme mode is success', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
        key: themeModeKey,
        value: testThemeMode,
      )).thenAnswer((_) async => true);
      // Act
      final result = await dataSource.saveThemeMode(testThemeMode);
      // Assert
      expect(result, true);
    });

    test('should return null when save theme mode is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
        key: themeModeKey,
        value: testThemeMode,
      )).thenThrow(Exception());
      // Act
      final result = await dataSource.saveThemeMode(testThemeMode);
      // Assert
      expect(result, false);
    });
  });

  group('getSavedThemeMode', () {
    test('should return saved theme mode when success', () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: themeModeKey))
          .thenAnswer((_) async => testThemeMode);
      // Act
      final result = await dataSource.getSavedThemeMode();
      // Assert
      final themeMode =
          ThemeMode.values.firstWhere((e) => e.name == testThemeMode);
      expect(result, themeMode);
    });

    test('should return null when theme not saved', () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: themeModeKey))
          .thenAnswer((_) async => null);
      // Act
      final result = await dataSource.getSavedThemeMode();
      // Assert
      expect(result, null);
    });
  });
}
