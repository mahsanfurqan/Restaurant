import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';

class AddMenuController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final kategoriController = TextEditingController();
  final deskripsiController = TextEditingController();
  final hargaController = TextEditingController();

  var image = Rxn<dynamic>();
  var selectedKategori = Rxn<CategoryModel>();
  var kategoriList = <CategoryModel>[].obs;

  final submitState = Rx<ResultState<bool>>(const ResultState.initial());

  final MenuRepository menuRepository = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final result = await menuRepository.fetchCategories();
    result.when(
      initial: () {},
      loading: () {},
      success: (data) => kategoriList.assignAll(data),
      failed: (msg) => kategoriList.assignAll([]),
    );
  }

  String? validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.menuNameRequired();
    }
    return null;
  }

  String? validateKategori(CategoryModel? value) {
    if (value == null) return AppLocalizations.categoryRequired();
    return null;
  }

  String? validateHarga(String? value) {
    final numeric = value?.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeric == null || numeric.isEmpty)
      return AppLocalizations.priceRequired();
    if (double.tryParse(numeric) == null)
      return AppLocalizations.priceMustBeNumber();
    return null;
  }

  bool get isFormValid =>
      image.value != null &&
      validateNama(namaController.text) == null &&
      selectedKategori.value != null &&
      validateHarga(hargaController.text) == null;

  Future<void> submit({
    Function(String message)? onFailed,
    Function(bool success)? onSuccess,
  }) async {
    if (!isFormValid) return;
    if (!formKey.currentState!.validate()) return;

    submitState.value = const ResultState.loading();

    final request = MenuRequestModel(
      name: namaController.text,
      description: deskripsiController.text,
      photoUrl: image.value?.path ?? '',
      price: int.tryParse(
              hargaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0,
      isAvailable: true, // atau sesuai kebutuhan
      categoryId: selectedKategori.value?.id ?? 0,
      restaurantId: 1, // ganti sesuai kebutuhan aplikasi
    );

    try {
      await menuRepository.createMenu(request);
      submitState.value = const ResultState.success(true);
      onSuccess?.call(true);
      Get.back();
    } catch (e) {
      submitState.value = ResultState.failed('Failed to add menu');
      onFailed?.call('Failed to add menu');
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    kategoriController.dispose();
    deskripsiController.dispose();
    hargaController.dispose();
    super.onClose();
  }
}
