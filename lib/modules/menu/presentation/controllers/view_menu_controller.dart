import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/dummy_data/dummy_menu.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';

class ViewMenuController extends GetxController {
  final menuState =
      Rx<ResultState<List<MenuModel>>>(const ResultState.initial());

  @override
  void onInit() {
    super.onInit();
    fetchDummyMenus();
  }

  Future<void> fetchDummyMenus() async {
    menuState.value = const ResultState.loading();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final menus = dummyMenuList.map((e) => MenuModel.fromJson(e)).toList();
      menuState.value = ResultState.success(menus);
    } catch (e) {
      menuState.value = ResultState.failed('Failed to load menu data');
    }
  }

  Future<void> refreshMenu() async {
    await fetchDummyMenus();
  }
}
