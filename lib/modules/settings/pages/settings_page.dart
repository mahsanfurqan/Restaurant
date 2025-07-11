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
import 'package:flutter_boilerplate/shared/helpers/alert_dialog_helper.dart';
import '../widgets/restaurant_info_widget.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserProfile();
    });

    final theme = context.theme;
    final localizationCtrl = Get.find<LocalizationController>();
    final themeCtrl = Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.settingsTitle(),
          style: AppFonts.lgBold.copyWith(color: Colors.black),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.email(),
                                      style: AppFonts.smRegular
                                          .copyWith(color: Colors.grey[700])),
                                  Obx(() => Text(
                                      controller.userEmail.value.isEmpty
                                          ? '-'
                                          : controller.userEmail.value,
                                      style: AppFonts.mdSemiBold
                                          .copyWith(color: AppColors.green))),
                                  const SizedBox(height: 8),
                                  Text(AppLocalizations.username(),
                                      style: AppFonts.smRegular
                                          .copyWith(color: Colors.grey[700])),
                                  Obx(() => Text(
                                      controller.userName.value.isEmpty
                                          ? '-'
                                          : controller.userName.value,
                                      style: AppFonts.smRegular.copyWith(
                                          color: AppColors.green
                                              .withOpacity(0.7)))),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppColors.green),
                              onPressed: () async {
                                final emailController = TextEditingController(
                                    text: controller.userEmail.value);
                                final userNameController =
                                    TextEditingController(
                                        text: controller.userName.value);
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(AppLocalizations.editProfile()),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                              labelText:
                                                  AppLocalizations.email()),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: userNameController,
                                          decoration: InputDecoration(
                                              labelText:
                                                  AppLocalizations.username()),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(AppLocalizations.cancel()),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final authState = controller
                                              .authCtrl.authState.value;
                                          final userId = authState.maybeWhen(
                                            success: (data) => data.id,
                                            orElse: () => null,
                                          );
                                          if (userId != null) {
                                            final success = await controller
                                                .updateUserProfile(userId, {
                                              'email': emailController.text,
                                              'username':
                                                  userNameController.text,
                                            });
                                            Navigator.of(context).pop(success);
                                          }
                                        },
                                        child: Text(AppLocalizations.save()),
                                      ),
                                    ],
                                  ),
                                );
                                if (result == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(AppLocalizations
                                            .profileUpdateSuccess())),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            AppLocalizations.accountTitle(),
            style: AppFonts.lgBold.copyWith(color: AppColors.green),
          ),
          const SizedBox(height: 12),
          RestaurantInfoWidget(),
          const SizedBox(height: 12),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(AppLocalizations.logout(),
                      style: AppFonts.mdSemiBold.copyWith(color: Colors.red)),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.confirm()),
                        content: Text(AppLocalizations.logoutMessage()),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: Text(AppLocalizations.cancel()),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: Text(AppLocalizations.logout()),
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
                          Get.back();
                          Get.offAllNamed(AppRoutes.login);
                          AlertDialogHelper.showSuccess(
                            AppLocalizations.logoutSuccess(),
                            title: AppLocalizations.successTitle(),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
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
        ],
      ),
    );
  }
}
