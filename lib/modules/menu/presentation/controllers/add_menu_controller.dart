import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';

class AddMenuController extends GetxController {
  final MenuRepository menuRepository;
  AddMenuController(this.menuRepository);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  var image = Rxn<dynamic>();
  var selectedCategory = Rxn<CategoryModel>();
  var categoryList = <CategoryModel>[].obs;

  final submitState = Rx<ResultState<bool>>(const ResultState.initial());

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final result = await menuRepository.fetchCategories();
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

    final request = MenuRequestModel(
      name: nameController.text,
      description: descriptionController.text,
      photoUrl: image.value?.path ?? '',
      price: int.tryParse(
              priceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0,
      isAvailable: true,
      categoryId: selectedCategory.value?.id ?? 0,
      restaurantId: 1,
    );

    final result = await menuRepository.createMenu(request);
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      submitState.value = ResultState.failed();
      onFailed?.call(message ?? '');
    }, (data) {
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
