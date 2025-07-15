import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/shared/widgets/app_alert_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ViewMenuController extends GetxController {
  final MenuRepository _repository;

  ViewMenuController(this._repository);

  final menuState =
      Rx<ResultState<List<MenuModel>>>(const ResultState.initial());
  final isOfflineMode = false.obs;
  final hasCachedData = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    menuState.value = const ResultState.loading();

    final result = await _repository.fetchMenus();
    result.fold(
      (failure) {
        isOfflineMode.value = true;
        hasCachedData.value = false;
        final message = AppUtils.getErrorMessage(failure.error?.errors);
        menuState.value = ResultState.failed(message ?? 'Gagal memuat menu');
      },
      (menus) {
        isOfflineMode.value = false;
        hasCachedData.value = false;
        menuState.value = ResultState.success(menus);
      },
    );
  }

  Future<void> refreshMenu() async {
    final result = await _repository.refreshMenus();
    result.fold(
      (failure) {
        isOfflineMode.value = true;
        hasCachedData.value = false;
        final message = AppUtils.getErrorMessage(failure.error?.errors);
        menuState.value = ResultState.failed(message ?? 'Gagal memuat menu');
      },
      (menus) {
        isOfflineMode.value = false;
        hasCachedData.value = false;
        menuState.value = ResultState.success(menus);
      },
    );
  }

  Future<bool> deleteMenu(int id) async {
    final result = await _repository.deleteMenu(id);
    return result.isRight();
  }

  Future<void> clearCache() async {
    await _repository.clearCache();
    hasCachedData.value = false;
  }

  bool get isCurrentlyOffline => isOfflineMode.value;
  bool get hasCachedDataAvailable => hasCachedData.value;
  Future<ResultState<bool>> editMenuWithResult(
    int id,
    MenuRequestModel request,
  ) async {
    final result = await _repository.updateMenu(id, request);

    return result.fold(
      (failure) {
        final msg = AppUtils.getErrorMessage(failure.error?.errors);
        return ResultState.failed(msg ?? 'Gagal mengedit menu');
      },
      (res) {
        fetchMenus();
        return const ResultState.success(true);
      },
    );
  }

  Future<ResultState<bool>> editMenuFromFields({
    required int menuId,
    required TextEditingController nameCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController descCtrl,
    required MenuModel menu,
    required int restaurantId,
  }) async {
    final request = MenuRequestModel(
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim(),
      photoUrl: menu.photoUrl ?? '',
      price:
          int.tryParse(priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      isAvailable: true,
      categoryId: menu.category!.id,
      restaurantId: restaurantId,
    );
    return await editMenuWithResult(menuId, request);
  }
}
