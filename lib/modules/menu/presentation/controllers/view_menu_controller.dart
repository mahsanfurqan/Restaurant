import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';

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
      (failure) {
        menuState.value = ResultState.failed('Gagal memuat menu');
      },
      (response) {
        menuState.value = ResultState.success(response.data ?? []);
      },
    );
  }

  Future<void> refreshMenu() async {
    await fetchMenus();
  }

  Future<bool> deleteMenu(int id) async {
    final result = await _menuRepository.deleteMenu(id);
    return result.isRight();
  }
}
