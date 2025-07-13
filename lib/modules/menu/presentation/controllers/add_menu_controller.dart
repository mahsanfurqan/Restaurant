import 'package:flutter/material.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final _image = Rxn<dynamic>();
  final _selectedCategory = Rxn<CategoryModel>();
  final _categoryList = <CategoryModel>[].obs;

  final _submitState = Rx<ResultState<bool>>(const ResultState.initial());
  String? _uploadedPhotoUrl;

  // Getters
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get categoryController => _categoryController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get priceController => _priceController;
  Rxn<dynamic> get image => _image;
  Rxn<CategoryModel> get selectedCategory => _selectedCategory;
  List<CategoryModel> get categoryList => _categoryList;
  ResultState<bool> get submitState => _submitState.value;
  String? get uploadedPhotoUrl => _uploadedPhotoUrl;

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
        _uploadedPhotoUrl = null;
        onFailed?.call(message ?? '');
      },
      (data) {
        _uploadedPhotoUrl = data.data?.url ?? '';
        onSuccess?.call(data.data?.url ?? '');
      },
    );
  }

  Future<void> _fetchCategories() async {
    final result = await _repository.fetchCategories();
    result.fold(
      (failure) => _categoryList.assignAll([]),
      (data) => _categoryList.assignAll(data),
    );
  }

  bool get isFormValid =>
      _image.value != null &&
      _nameController.text.isNotEmpty &&
      _selectedCategory.value != null &&
      _priceController.text.isNotEmpty &&
      double.tryParse(_priceController.text) != null;

  Future<void> submit({
    Function(String message)? onFailed,
    Function(bool success)? onSuccess,
  }) async {
    if (_formKey.currentState?.validate() == false) return;
    _submitState.value = const ResultState.loading();

    final restaurantId = Get.find<AuthController>().authState.value.maybeWhen(
          success: (data) => data.restaurantId,
          orElse: () => null,
        );

    if (restaurantId == null) {
      _submitState.value = const ResultState.failed("User tidak valid.");
      onFailed?.call("User tidak valid.");
      return;
    }

    final request = MenuRequestModel(
      name: _nameController.text,
      description: _descriptionController.text,
      photoUrl: _uploadedPhotoUrl ?? '',
      price: int.tryParse(
              _priceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0,
      isAvailable: true,
      categoryId: _selectedCategory.value?.id ?? 0,
      restaurantId: restaurantId,
    );

    final result = await _repository.createMenu(request);
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      _submitState.value = ResultState.failed(message);
      onFailed?.call(message ?? '');
    }, (response) {
      _submitState.value = const ResultState.success(true);
      onSuccess?.call(true);
    });
  }

  @override
  void onClose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.onClose();
  }
}
