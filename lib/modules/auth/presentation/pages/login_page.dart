import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/login_controller.dart';
import 'package:flutter_boilerplate/shared/helpers/bottom_sheet_helper.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final localizationCtrl = Get.find<LocalizationController>();

    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:
            (context.isDarkMode) ? AppColors.darkBackground : AppColors.white,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: context.mediaQuerySize.height,
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      final currentLocale =
                          localizationCtrl.currentLocale.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            currentLocale.languageCode == 'id'
                                ? 'Bahasa Indonesia'
                                : 'English',
                            style: AppFonts.smRegular,
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
                              trackColor:
                                  WidgetStatePropertyAll(AppColors.green),
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
                      );
                    }),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        AppLocalizations.login(),
                        style: AppFonts.xlBold.copyWith(
                          fontSize: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorScheme.surfaceBright,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.loginSubtitle(),
                              style: AppFonts.smRegular.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.username(),
                                      style: AppFonts.mdSemiBold,
                                    ),
                                    const SizedBox(height: 8),
                                    AppInput(
                                      controller: controller.unameCtrl,
                                      hintText: AppLocalizations
                                          .usernamePlaceholder(),
                                      validator: FormBuilderValidators.required(
                                        errorText: AppLocalizations
                                            .usernameRequiredMessage(),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Text(
                                      AppLocalizations.password(),
                                      style: AppFonts.mdSemiBold,
                                    ),
                                    const SizedBox(height: 8),
                                    AppInput.password(
                                      controller: controller.passCtrl,
                                      hintText: AppLocalizations
                                          .passwordPlaceholder(),
                                      validator: AppUtils.passwordValidator(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Obx(
                                  () => AppButton(
                                    isLoading: controller.loginState.value
                                        is ResultLoading,
                                    onPressed: () => controller.login(
                                      onFailed: (message) {
                                        if (Get.isBottomSheetOpen == false) {
                                          BottomSheetHelper.showError(message);
                                        }
                                      },
                                      onSuccess: (_) async {
                                        Get.offNamed(AppRoutes.lihatMenu);
                                        await authCtrl.authCheck();
                                      },
                                    ),
                                    text: AppLocalizations.login(),
                                    backgroundColor: AppColors.green,
                                    textColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.dontHaveAccount(),
                                      style: AppFonts.smRegular
                                          .copyWith(color: AppColors.grey),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.register);
                                      },
                                      child: Text(
                                        AppLocalizations.register(),
                                        style: AppFonts.smBold
                                            .copyWith(color: AppColors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
