import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/shared/widgets/custom_navbar.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import '../controllers/lihat_menu_controller.dart';
import 'package:flutter_boilerplate/shared/widgets/menu_list.dart';
import 'package:flutter_boilerplate/shared/widgets/detail_menu.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';

class LihatMenuPage extends GetView<LihatMenuController> {
  const LihatMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationCtrl = Get.find<LocalizationController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.lihatMenuTitle()),
      ),
      body: SafeArea(
        child: Obx(() {
          localizationCtrl.currentLocale.value;
          return MenuList(
            menus: controller.menuList,
            isLoading: controller.isLoading.value,
            isError: controller.isError.value,
            isEmpty: controller.menuList.isEmpty &&
                !controller.isLoading.value &&
                !controller.isError.value,
            onRefresh: controller.refreshMenu,
            onTap: (menu) {
              Get.bottomSheet(
                DetailMenu(
                  menu: menu,
                  onEditSuccess: () {
                    controller.fetchDummyMenus();
                  },
                ),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
              );
            },
          );
        }),
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          // TODO: Implement navigation if needed
        },
      ),
      floatingActionButton: AppButton(
        onPressed: () {
          Get.toNamed(AppRoutes.tambahMenu);
        },
        text: '',
        height: 70,
        width: 70,
        radius: 35,
        prefixIcon: const Icon(Icons.add, color: Colors.white, size: 20),
        backgroundColor: AppColors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
