import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
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
        actions: [
          Obx(() => controller.isOfflineMode.value
              ? Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.offline(),
                          style: AppFonts.smRegular.copyWith()),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          localizationCtrl.currentLocale.value;
          final state = controller.menuState;

          return state.value.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (menus) => menus.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.menuNotFound(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (controller.isOfflineMode.value) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Data dari cache',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // Offline banner
                      if (controller.isOfflineMode.value)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: Colors.orange.withOpacity(0.1),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  AppLocalizations.offline(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: controller.refreshMenu,
                                child: Text(
                                  AppLocalizations.refreshing(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Menu list
                      Expanded(
                        child: AppRefresher(
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
                                        onEditSuccess: () =>
                                            controller.fetchMenus(),
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
                      ),
                    ],
                  ),
            failed: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message ?? AppLocalizations.menuNotFound(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
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
