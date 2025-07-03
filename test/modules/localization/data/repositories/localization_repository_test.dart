import 'dart:ui';

import 'package:flutter_boilerplate/modules/localization/data/repositories/localization_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LocalizationRepository repository;
  late MockLocalizationLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalizationLocalDataSource();
    repository = LocalizationRepository(mockLocalDataSource);
  });

  const testLocale = 'id';

  group('saveLocale', () {
    test('should return true when save locale is success', () async {
      // Arrange
      when(mockLocalDataSource.saveLocale(testLocale))
          .thenAnswer((_) async => true);
      // Act
      final result = await repository.saveLocale(testLocale);
      // Assert
      verify(mockLocalDataSource.saveLocale(testLocale));
      expect(result, true);
    });

    test('should return false when save locale is failed', () async {
      // Arrange
      when(mockLocalDataSource.saveLocale(testLocale))
          .thenAnswer((_) async => false);
      // Act
      final result = await repository.saveLocale(testLocale);
      // Assert
      expect(result, false);
    });
  });

  group('getSavedLocale', () {
    test('should return saved locale when success', () async {
      // Arrange
      when(mockLocalDataSource.getSavedLocale())
          .thenAnswer((_) async => const Locale(testLocale));
      // Act
      final result = await repository.getSavedLocale();
      // Assert
      expect(result, const Locale(testLocale));
    });

    test('should return null when locale not saved', () async {
      // Arrange
      when(mockLocalDataSource.getSavedLocale()).thenAnswer((_) async => null);
      // Act
      final result = await repository.getSavedLocale();
      // Assert
      expect(result, null);
    });
  });
}
