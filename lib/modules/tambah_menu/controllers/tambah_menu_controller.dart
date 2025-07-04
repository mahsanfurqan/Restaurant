import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/dummy_data/dummy_kategori.dart';
import 'package:flutter_boilerplate/modules/lihat_menu/controllers/lihat_menu_controller.dart';
import 'package:flutter_boilerplate/shared/models/menu_model.dart';

class TambahMenuController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final kategoriController = TextEditingController();
  final deskripsiController = TextEditingController();
  final hargaController = TextEditingController();

  var image = Rxn<dynamic>();
  var isLoading = false.obs;
  var errorMessage = RxnString();
  var selectedKategori = RxnString();
  var kategoriList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    kategoriList.assignAll(dummyKategori);
  }

  String? validateNama(String? value) {
    if (value == null || value.isEmpty)
      return AppLocalizations.menuNameRequired();
    return null;
  }

  String? validateKategori(String? value) {
    if (value == null || value.isEmpty)
      return AppLocalizations.categoryRequired();
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

  Future<void> submit() async {
    if (!isFormValid) return;
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    errorMessage.value = null;
    await Future.delayed(const Duration(seconds: 2));
    final newMenu = MenuModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: namaController.text,
      imageUrl: image.value?.path != null
          ? image.value!.path // Untuk demo, gunakan path lokal
          : 'https://via.placeholder.com/150',
      price: int.tryParse(
              hargaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0,
      kategori: selectedKategori.value ?? '',
      description: deskripsiController.text,
    );
    Get.find<LihatMenuController>().menuList.add(newMenu);
    isLoading.value = false;
    Get.back();
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
