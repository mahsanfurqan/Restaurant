import 'dart:ui';

import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LocalizationController controller;
  late MockLocalizationRepository mockLocalizationRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    mockLocalizationRepository = MockLocalizationRepository();
    controller = LocalizationController(mockLocalizationRepository);
  });

  final testLocale = 'en';
  final testDefaultLocale = 'id';

  group('saveLocale', () {
    test('currentLocale should be updated when save locale is success',
        () async {
      // Arrange
      when(mockLocalizationRepository.saveLocale(testLocale))
          .thenAnswer((_) async => true);
      when(mockLocalizationRepository.getSavedLocale())
          .thenAnswer((_) async => Locale(testLocale));
      // Act
      await controller.saveLocale(Locale(testLocale));
      // Assert
      expect(controller.currentLocale.value, Locale(testLocale));
    });

    test('currentLocale should not be updated when save locale is failed',
        () async {
      // Arrange
      when(mockLocalizationRepository.saveLocale(testLocale))
          .thenAnswer((_) async => false);
      // Act
      await controller.saveLocale(Locale(testLocale));
      // Assert
      expect(controller.currentLocale.value, Locale(testDefaultLocale));
    });
  });

  group('getCurrentLocale', () {
    test('currentLocale value should be saved locale when success', () async {
      // Arrange
      when(mockLocalizationRepository.getSavedLocale())
          .thenAnswer((_) async => Locale(testLocale));
      // Act
      await controller.getCurrentLocale();
      // Assert
      expect(controller.currentLocale.value, Locale(testLocale));
    });

    test('currentLocale value should be default locale when failed', () async {
      // Arrange
      when(mockLocalizationRepository.getSavedLocale())
          .thenAnswer((_) async => null);
      // Act
      await controller.getCurrentLocale();
      // Assert
      expect(controller.currentLocale.value, Locale(testDefaultLocale));
    });
  });
}
