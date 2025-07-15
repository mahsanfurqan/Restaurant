import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/common/network_info.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';

class AddMenuController extends GetxController {
  final MenuRepository _repository;

  AddMenuController(this._repository);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final image = Rxn<dynamic>();
  final selectedCategory = Rxn<CategoryModel>();
  final categoryList = <CategoryModel>[].obs;

  final submitState = Rx<ResultState<bool>>(const ResultState.initial());
  String? uploadedPhotoUrl;

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
  }

  Future<void> uploadImageFile(
    String filePath, {
    Function(String message)? onFailed,
    Function(String imageUrl)? onSuccess,
  }) async {
    final result = await _repository.uploadFile(
      filePath: filePath,
      folder: 'menu',
    );

    result.fold(
      (failure) {
        final message = AppUtils.getErrorMessage(failure.error?.errors);
        uploadedPhotoUrl = null;
        onFailed?.call(message ?? '');
      },
      (data) {
        uploadedPhotoUrl = data.data?.url ?? '';
        onSuccess?.call(data.data?.url ?? '');
      },
    );
  }

  Future<void> _fetchCategories() async {
    final hasInternet = await Get.find<NetworkInfo>().isConnected;
    if (!hasInternet) {
      categoryList.assignAll([]);
      return;
    }
    final result = await _repository.fetchCategories(forceRefresh: true);
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
      submitState.value =
          ResultState.failed(AppLocalizations.restaurantNotFound());
      onFailed?.call(AppLocalizations.restaurantNotFound());
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

    final result = await _repository.createMenu(request);
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      submitState.value = ResultState.failed(message);
      onFailed?.call(message ?? '');
    }, (response) {
      submitState.value = const ResultState.success(true);
      onSuccess?.call(true);
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
