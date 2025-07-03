import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ThemeController controller;
  late MockThemeRepository mockThemeRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    mockThemeRepository = MockThemeRepository();
    controller = ThemeController(mockThemeRepository);
  });

  final testThemeMode = ThemeMode.dark;
  final testDefaultThemeMode = ThemeMode.system;

  group('saveThemeMode', () {
    test('currentThemeMode should be updated when save theme mode is success',
        () async {
      // Arrange
      when(mockThemeRepository.saveThemeMode(testThemeMode.name))
          .thenAnswer((_) async => true);
      when(mockThemeRepository.getSavedThemeMode())
          .thenAnswer((_) async => testThemeMode);
      // Act
      await controller.saveThemeMode(testThemeMode);
      // Assert
      expect(controller.currentThemeMode.value, testThemeMode);
    });

    test(
        'currentThemeMode should not be updated when save theme mode is failed',
        () async {
      // Arrange
      when(mockThemeRepository.saveThemeMode(testThemeMode.name))
          .thenAnswer((_) async => false);
      // Act
      await controller.saveThemeMode(testThemeMode);
      // Assert
      expect(controller.currentThemeMode.value, testDefaultThemeMode);
    });
  });

  group('getCurrentThemeMode', () {
    test('currentThemeMode value should be saved theme mode when success',
        () async {
      // Arrange
      when(mockThemeRepository.getSavedThemeMode())
          .thenAnswer((_) async => testThemeMode);
      // Act
      await controller.getCurrentThemeMode();
      // Assert
      expect(controller.currentThemeMode.value, testThemeMode);
    });

    test('currentThemeMode value should be default theme mode when failed',
        () async {
      // Arrange
      when(mockThemeRepository.getSavedThemeMode())
          .thenAnswer((_) async => null);
      // Act
      await controller.getCurrentThemeMode();
      // Assert
      expect(controller.currentThemeMode.value, testDefaultThemeMode);
    });
  });
}
