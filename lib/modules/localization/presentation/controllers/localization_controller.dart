import 'dart:ui';

import 'package:flutter_boilerplate/modules/localization/data/repositories/localization_repository.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  final LocalizationRepository _repository;

  LocalizationController(this._repository);

  @override
  void onInit() async {
    super.onInit();
    await getCurrentLocale();
  }

  final currentLocale = Locale('id').obs;

  Future<void> saveLocale(Locale locale) async {
    final localeSaved = await _repository.saveLocale(locale.languageCode);
    if (localeSaved) {
      final savedLocale = await _repository.getSavedLocale();
      currentLocale.value = savedLocale ?? Locale('id');
    }
  }

  Future<void> getCurrentLocale() async {
    final savedLocale = await _repository.getSavedLocale();
    currentLocale.value = savedLocale ?? Locale('id');
  }
}
