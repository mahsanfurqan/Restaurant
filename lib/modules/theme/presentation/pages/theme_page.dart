import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/widgets/theme_setting_item.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:get/get.dart';

class ThemePage extends GetView<ThemeController> {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.displayMode()),
      ),
      body: SafeArea(
        child: Obx(() {
          final isSystemMode =
              controller.currentThemeMode.value == ThemeMode.system;
          final isLightMode =
              controller.currentThemeMode.value == ThemeMode.light;
          final isDarkMode =
              controller.currentThemeMode.value == ThemeMode.dark;

          return ListView(
            children: [
              ThemeSettingItem(
                value: isSystemMode,
                onChanged: (_) {
                  controller.saveThemeMode(ThemeMode.system);
                },
                title: AppLocalizations.system(),
                subtitle: AppLocalizations.systemModeDesc(),
              ),
              ThemeSettingItem(
                value: isLightMode,
                onChanged: (_) {
                  controller.saveThemeMode(ThemeMode.light);
                },
                title: AppLocalizations.lightMode(),
                subtitle: AppLocalizations.lightModeDesc(),
              ),
              ThemeSettingItem(
                value: isDarkMode,
                onChanged: (_) {
                  controller.saveThemeMode(ThemeMode.dark);
                },
                title: AppLocalizations.darkMode(),
                subtitle: AppLocalizations.darkModeDesc(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
