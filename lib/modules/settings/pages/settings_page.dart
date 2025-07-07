import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/modules/main/widgets/custom_navbar.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizationCtrl = Get.find<LocalizationController>();
    final themeCtrl = Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.settingsTitle(),
          style: AppFonts.lgBold.copyWith(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Get.back();
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.green.withOpacity(0.15),
                    child: const Icon(Icons.person,
                        size: 32, color: AppColors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('-',
                            style: AppFonts.mdSemiBold
                                .copyWith(color: AppColors.green)),
                        const SizedBox(height: 4),
                        Text('-',
                            style: AppFonts.smRegular.copyWith(
                                color: AppColors.green.withOpacity(0.7))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            AppLocalizations.preferencesTitle(),
            style: AppFonts.lgBold.copyWith(color: AppColors.green),
          ),
          const SizedBox(height: 12),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_rounded,
                      color: AppColors.green),
                  title: Text(AppLocalizations.themeTitle(),
                      style: AppFonts.mdSemiBold),
                  subtitle: Text(AppLocalizations.themeSubtitle(),
                      style: AppFonts.smRegular),
                  trailing: Obx(() => Switch(
                        value: controller.isDarkTheme.value,
                        onChanged: (val) {
                          controller.isDarkTheme.value = val;
                          themeCtrl.saveThemeMode(
                              val ? ThemeMode.dark : ThemeMode.light);
                        },
                        activeColor: AppColors.green,
                        activeTrackColor: AppColors.green.withOpacity(0.3),
                      )),
                ),
                Divider(height: 0),
                Obx(() {
                  final currentLocale = localizationCtrl.currentLocale.value;
                  return ListTile(
                    leading: const Icon(Icons.language, color: AppColors.green),
                    title: Text(AppLocalizations.languageTitle(),
                        style: AppFonts.mdSemiBold),
                    subtitle: Text(AppLocalizations.languageSubtitle(),
                        style: AppFonts.smRegular),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentLocale.languageCode == 'id'
                              ? AppLocalizations.bahasaIndonesia()
                              : AppLocalizations.english(),
                          style:
                              AppFonts.smBold.copyWith(color: AppColors.green),
                        ),
                        const SizedBox(width: 8),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: currentLocale.languageCode == 'id',
                            activeThumbImage:
                                AssetImage('assets/images/id_flag.png'),
                            inactiveThumbImage:
                                AssetImage('assets/images/en_flag.png'),
                            trackColor: WidgetStatePropertyAll(AppColors.green),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            trackOutlineColor:
                                WidgetStatePropertyAll(AppColors.green),
                            onChanged: (value) {
                              final selectedLocale =
                                  value ? Locale('id') : Locale('en');
                              localizationCtrl.saveLocale(selectedLocale);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            AppLocalizations.accountTitle(),
            style: AppFonts.lgBold.copyWith(color: AppColors.green),
          ),
          const SizedBox(height: 12),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restaurant_menu_rounded,
                      color: AppColors.green),
                  title: Text(AppLocalizations.restaurantSettingTitle(),
                      style: AppFonts.mdSemiBold),
                  subtitle: Text(AppLocalizations.restaurantSettingSubtitle(),
                      style: AppFonts.smRegular),
                  onTap: () {
                    // Navigasi ke halaman pengaturan restaurant
                  },
                ),
                Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(AppLocalizations.logout(),
                      style: AppFonts.mdSemiBold.copyWith(color: Colors.red)),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text('Apakah Anda yakin ingin logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                      await controller.logout(
                        onSuccess: () {
                          Get.back(); // close loading
                          Get.offAllNamed(AppRoutes.login);
                          Get.snackbar('Sukses', 'Berhasil logout',
                              backgroundColor: Colors.green[100]);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
