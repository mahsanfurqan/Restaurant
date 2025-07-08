import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';

class ViewMenuController extends GetxController {
  final MenuRepository menuRepository;
  ViewMenuController(this.menuRepository);

  final menuState =
      Rx<ResultState<List<MenuModel>>>(const ResultState.initial());

  @override
  void onInit() {
    super.onInit();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    menuState.value = const ResultState.loading();
    final result = await menuRepository.fetchMenus();
    result.fold(
      (failure) =>
          menuState.value = ResultState.failed(_getErrorMessage(failure)),
      (data) => menuState.value = ResultState.success(data),
    );
  }

  String _getErrorMessage(Failure failure) {
    return failure.message ?? 'Failed to load menu data';
  }

  Future<void> refreshMenu() async {
    await fetchMenus();
  }
}
