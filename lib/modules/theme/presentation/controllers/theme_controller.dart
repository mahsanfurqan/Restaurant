import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/theme/data/repositories/theme_repository.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final ThemeRepository _repository;

  ThemeController(this._repository);

  @override
  void onInit() async {
    super.onInit();
    await getCurrentThemeMode();
  }

  final currentThemeMode = ThemeMode.system.obs;

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final themeModeSaved = await _repository.saveThemeMode(themeMode.name);
    if (themeModeSaved) {
      final savedThemeMode = await _repository.getSavedThemeMode();
      currentThemeMode.value = savedThemeMode ?? ThemeMode.system;
    }
  }

  Future<void> getCurrentThemeMode() async {
    final savedThemeMode = await _repository.getSavedThemeMode();
    currentThemeMode.value = savedThemeMode ?? ThemeMode.system;
  }
}
