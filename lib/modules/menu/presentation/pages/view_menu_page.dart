import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/main/widgets/custom_navbar.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import '../controllers/view_menu_controller.dart';
import '../widgets/menu_list.dart';
import '../widgets/detail_menu.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';

class ViewMenuPage extends GetView<ViewMenuController> {
  const ViewMenuPage({Key? key}) : super(key: key);

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
          final state = controller.menuState.value;

          if (state is ResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResultSuccess<List<MenuModel>>) {
            final menus = state.data;
            return MenuList(
              menus: menus,
              isLoading: false,
              isError: false,
              isEmpty: menus.isEmpty,
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                );
              },
            );
          } else if (state is ResultFailed<List<MenuModel>>) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message ?? 'Failed to load menu data'),
                  ElevatedButton(
                    onPressed: controller.refreshMenu,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        }),
      ),
      floatingActionButton: AppButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addMenu);
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
