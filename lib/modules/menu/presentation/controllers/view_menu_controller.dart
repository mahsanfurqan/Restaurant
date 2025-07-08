import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';

class ViewMenuController extends GetxController {
  final MenuRepository _menuRepository;
  ViewMenuController(this._menuRepository);

  final menuState =
      Rx<ResultState<List<MenuModel>>>(const ResultState.initial());

  @override
  void onInit() {
    super.onInit();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    menuState.value = const ResultState.loading();
    final result = await _menuRepository.fetchMenus();
    result.fold(
      (failure) => menuState.value = ResultState.failed(
          AppUtils.getErrorMessage(failure.error?.errors) ??
              'Failed to load menu data'),
      (data) => menuState.value = ResultState.success(data),
    );
  }

  Future<void> refreshMenu() async {
    await fetchMenus();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
