import 'dart:ui';

import 'package:flutter_boilerplate/modules/localization/data/data_sources/local/localization_local_data_source.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late LocalizationLocalDataSource dataSource;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    dataSource = LocalizationLocalDataSource(
      mockFlutterSecureStorage,
    );
  });

  final localeKey = AppConstants.secureStorageKeys.locale;
  final testIdLocale = 'id';

  group('saveLocale', () {
    test('should return true when save locale is success', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(key: localeKey, value: testIdLocale))
          .thenAnswer((_) async => true);
      // Act
      final result = await dataSource.saveLocale(testIdLocale);
      // Assert
      expect(result, true);
    });

    test('should return false when save ID local is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(key: localeKey, value: testIdLocale))
          .thenThrow(Exception());
      // Act
      final result = await dataSource.saveLocale(testIdLocale);
      // Assert
      expect(result, false);
    });
  });

  group('getSavedLocale', () {
    test('should return locale with correct language code when success',
        () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: localeKey))
          .thenAnswer((_) async => 'id');
      // Act
      final result = await dataSource.getSavedLocale();
      // Assert
      expect(result, Locale(testIdLocale));
    });

    test('should return null when the locale not saved in local', () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: localeKey))
          .thenAnswer((_) async => null);
      // Act
      final result = await dataSource.getSavedLocale();
      // Assert
      expect(result, null);
    });
  });
}
