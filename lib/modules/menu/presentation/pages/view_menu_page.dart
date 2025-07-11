import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/widgets/app_refresher.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import '../controllers/view_menu_controller.dart';
import '../widgets/menu_list.dart';
import '../widgets/detail_menu.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';

class ViewMenuPage extends GetView<ViewMenuController> {
  const ViewMenuPage({super.key});

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

          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (menus) => menus.isEmpty
                ? Center(child: Text(AppLocalizations.menuNotFound()))
                : AppRefresher(
                    onRefresh: controller.refreshMenu,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: menus.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return MenuListItem(
                          menu: menu,
                          onTap: () {
                            Get.bottomSheet(
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: Get.height * 0.8,
                                ),
                                child: DetailMenu(
                                  menu: menu,
                                  onEditSuccess: () => controller.fetchMenus(),
                                ),
                              ),
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
            failed: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message ?? AppLocalizations.menuNotFound()),
                  const SizedBox(height: 16),
                  AppButton(
                    onPressed: controller.refreshMenu,
                    text: AppLocalizations.retry(),
                    backgroundColor: AppColors.green,
                  ),
                ],
              ),
            ),
            initial: () => const SizedBox.shrink(),
          );
        }),
      ),
      floatingActionButton: AppButton(
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.addMenu);
          if (result == true) {
            controller.fetchMenus();
          }
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
