import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/connectivity/presentation/controllers/connectivity_controller.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/shared/helpers/bottom_sheet_helper.dart';
import 'package:flutter_boilerplate/shared/styles/app_themes.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_boilerplate/shared/utils/app_translations.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/routes/app_pages.dart';

void main() async {
  await AppUtils.initProject();
  await SentryFlutter.init(
    (opt) {
      opt.dsn = AppConstants.general.sentryDsn;
    },
    appRunner: () => runApp(const App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationCtrl = Get.find<LocalizationController>();
    final themeCtrl = Get.find<ThemeController>();

    return GetBuilder<ConnectivityController>(
      initState: (_) {
        final authState = Get.find<AuthController>().authState;
        final isConnected = Get.find<ConnectivityController>().isConnected;

        ever(localizationCtrl.currentLocale, (value) {
          Get.updateLocale(value);
        });

        ever(isConnected, (value) {
          if (!value && Get.isBottomSheetOpen == false) {
            BottomSheetHelper.showNoInternetBottomSheet();
          } else if (value && Get.isBottomSheetOpen == true) {
            Get.back();
          }
        });

        ever(authState, (value) {
          if (value is ResultSuccess<AuthValidateModel>) {
            Get.offNamed(AppRoutes.main);
          } else {
            Get.offNamed(AppRoutes.login);
          }
        });
      },
      builder: (_) {
        return Obx(
          () => GetMaterialApp(
            title: 'Flutter Restaurant',
            getPages: AppPages.pages,
            translations: AppTranslations(),
            locale: localizationCtrl.currentLocale.value,
            fallbackLocale: localizationCtrl.currentLocale.value,
            initialRoute: AppPages.initial,
            themeMode: themeCtrl.currentThemeMode.value,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
          ),
        );
      },
    );
  }
}
