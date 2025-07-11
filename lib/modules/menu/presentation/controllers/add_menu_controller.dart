import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';

class AddMenuController extends GetxController {
  final MenuRepository _menuRepository;

  AddMenuController(this._menuRepository);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  var image = Rxn<dynamic>();
  var selectedCategory = Rxn<CategoryModel>();
  var categoryList = <CategoryModel>[].obs;

  final submitState = ResultState<bool>.initial().obs;
  String? uploadedPhotoUrl;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> uploadImageFile(
    String filePath, {
    Function(String message)? onFailed,
    Function(String imageUrl)? onSuccess,
  }) async {
    final result = await _menuRepository.uploadFile(
      filePath: filePath,
      folder: 'menu',
    );

    result.fold(
      (failure) {
        final message = AppUtils.getErrorMessage(failure.error?.errors);
        uploadedPhotoUrl = null;
        onFailed?.call(message ?? 'Upload gagal');
      },
      (data) {
        uploadedPhotoUrl = data.url;
        onSuccess?.call(data.url);
      },
    );
  }

  Future<void> fetchCategories() async {
    final result = await _menuRepository.fetchCategories();
    result.fold(
      (failure) => categoryList.assignAll([]),
      (data) => categoryList.assignAll(data),
    );
  }

  bool get isFormValid =>
      image.value != null &&
      nameController.text.isNotEmpty &&
      selectedCategory.value != null &&
      priceController.text.isNotEmpty &&
      double.tryParse(priceController.text) != null;

  Future<void> submit({
    Function(String message)? onFailed,
    Function(bool success)? onSuccess,
  }) async {
    if (formKey.currentState?.validate() == false) return;
    submitState.value = const ResultState.loading();

    final restaurantId = Get.find<AuthController>().authState.value.maybeWhen(
          success: (data) => data.restaurantId,
          orElse: () => null,
        );

    if (restaurantId == null) {
      submitState.value = const ResultState.failed("User tidak valid.");
      onFailed?.call("User tidak valid.");
      return;
    }

    final request = MenuRequestModel(
      name: nameController.text,
      description: descriptionController.text,
      photoUrl: uploadedPhotoUrl ?? '',
      price: int.tryParse(
              priceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0,
      isAvailable: true,
      categoryId: selectedCategory.value?.id ?? 0,
      restaurantId: restaurantId,
    );

    final result = await _menuRepository.createMenu(request);
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      submitState.value = ResultState.failed(message);
      onFailed?.call(message ?? '');
    }, (response) {
      submitState.value = const ResultState.success(true);
      onSuccess?.call(true);

      Get.back();
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
