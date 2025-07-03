import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/theme/data/repositories/theme_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ThemeRepository repository;
  late MockThemeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockThemeLocalDataSource();
    repository = ThemeRepository(mockLocalDataSource);
  });

  final testThemeMode = ThemeMode.dark.name;

  group('saveThemeMode', () {
    test('should return true mode when save theme mode is success', () async {
      // Arrange
      when(mockLocalDataSource.saveThemeMode(testThemeMode))
          .thenAnswer((_) async => true);
      // Act
      final result = await repository.saveThemeMode(testThemeMode);
      // Assert
      expect(result, true);
    });

    test('should return false when save theme mode is failed', () async {
      // Arrange
      when(mockLocalDataSource.saveThemeMode(testThemeMode))
          .thenAnswer((_) async => false);
      // Act
      final result = await repository.saveThemeMode(testThemeMode);
      // Assert
      expect(result, false);
    });
  });

  group('getSavedThemeMode', () {
    test('should return saved theme mode when success', () async {
      // Arrange
      when(mockLocalDataSource.getSavedThemeMode())
          .thenAnswer((_) async => ThemeMode.dark);
      // Act
      final result = await repository.getSavedThemeMode();
      // Assert
      expect(result, ThemeMode.dark);
    });

    test('should return null when theme mode not saved in local', () async {
      // Arrange
      when(mockLocalDataSource.getSavedThemeMode())
          .thenAnswer((_) async => null);
      // Act
      final result = await repository.getSavedThemeMode();
      // Assert
      expect(result, null);
    });
  });
}
