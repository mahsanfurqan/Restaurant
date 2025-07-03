import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/modules/setting/presentation/controllers/setting_controller.dart';
import 'package:flutter_boilerplate/modules/setting/presentation/widgets/setting_item.dart';
import 'package:flutter_boilerplate/shared/helpers/alert_dialog_helper.dart';
import 'package:flutter_boilerplate/shared/helpers/bottom_sheet_helper.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_assets.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:get/get.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationCtrl = Get.find<LocalizationController>();

    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.settings()),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.dividerColor,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    foregroundImage: NetworkImage(
                      'https://avatar.iran.liara.run/public/21',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(() {
                    final userState = controller.userState.value;
                    final user = userState.whenOrNull(
                      success: (data) => data,
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '-',
                          style: AppFonts.mdRegular,
                        ),
                        Text(
                          user?.username ?? '-',
                          style: AppFonts.smRegular,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.preferences(),
              style: AppFonts.lgSemiBold,
            ),
            const SizedBox(height: 16),
            Obx(() {
              final currentLocale = localizationCtrl.currentLocale.value;
              return SettingItem(
                label: AppLocalizations.language(),
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    padding: EdgeInsets.zero,
                    value: currentLocale.languageCode ==
                        AppConstants.general.idLocale,
                    activeThumbImage: AssetImage(AppAssets.images.idFlag),
                    inactiveThumbImage: AssetImage(AppAssets.images.enFlag),
                    trackColor: WidgetStatePropertyAll(colorScheme.primary),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    trackOutlineColor:
                        WidgetStatePropertyAll(colorScheme.primary),
                    onChanged: (value) {
                      final selectedLocale = value
                          ? Locale(AppConstants.general.idLocale)
                          : Locale(AppConstants.general.enLocale);
                      localizationCtrl.saveLocale(selectedLocale);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.displayMode),
              child: SettingItem(
                label: AppLocalizations.displayMode(),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.account(),
              style: AppFonts.lgSemiBold,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => AlertDialogHelper.showLogout(
                onConfirm: () {
                  controller.logout(
                    onLoading: AlertDialogHelper.showLoading,
                    onFailed: BottomSheetHelper.showError,
                    onSuccess: (data) => Get.offAllNamed(
                      AppRoutes.login,
                    ),
                  );
                },
              ),
              child: SettingItem(
                label: AppLocalizations.logout(),
                textColor: colorScheme.error,
                trailing: Icon(
                  Icons.exit_to_app_rounded,
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
