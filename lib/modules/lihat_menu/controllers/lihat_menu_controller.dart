import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/dummy_data/dummy_menu.dart';

class LihatMenuController extends GetxController {
  var menuList = <MenuModel>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDummyMenus();
  }

  void fetchDummyMenus() async {
    isLoading.value = true;
    isError.value = false;
    await Future.delayed(const Duration(seconds: 1));
    menuList.assignAll(dummyMenuList);
    isLoading.value = false;
  }

  void refreshMenu() async {
    fetchDummyMenus();
  }
}
