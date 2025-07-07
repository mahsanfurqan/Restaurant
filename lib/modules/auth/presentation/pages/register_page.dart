import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_request_model.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';

class RegisterPage extends GetView<AuthController> {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _restaurantNameCtrl = TextEditingController();
  final TextEditingController _restaurantAddressCtrl = TextEditingController();
  final TextEditingController _restaurantDescriptionCtrl =
      TextEditingController();
  final TextEditingController _restaurantPhoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final localizationCtrl = Get.find<LocalizationController>();
    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:
            (context.isDarkMode) ? AppColors.darkBackground : AppColors.white,
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
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
                                      localizationCtrl
                                          .saveLocale(selectedLocale);
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              AppLocalizations.register(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.fullName(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput(
                                        controller: _nameCtrl,
                                        hintText: AppLocalizations
                                            .fullNamePlaceholder(),
                                        validator:
                                            FormBuilderValidators.required(
                                          errorText: AppLocalizations
                                              .usernameRequiredMessage(),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.registerUsername(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput(
                                        controller: _usernameCtrl,
                                        hintText: AppLocalizations
                                            .registerUsernamePlaceholder(),
                                        validator:
                                            FormBuilderValidators.required(
                                          errorText: AppLocalizations
                                              .registerUsernameRequiredMessage(),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.email(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput(
                                        controller: _emailCtrl,
                                        hintText:
                                            AppLocalizations.emailPlaceholder(),
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                            errorText: AppLocalizations
                                                .emailRequiredMessage(),
                                          ),
                                          FormBuilderValidators.email(
                                            errorText: AppLocalizations
                                                .emailInvalidMessage(),
                                          ),
                                        ]),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.password(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput.password(
                                        controller: _passwordCtrl,
                                        hintText: AppLocalizations
                                            .passwordPlaceholder(),
                                        validator:
                                            FormBuilderValidators.required(
                                          errorText: AppLocalizations
                                              .passwordRequiredMessage(),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.restaurantName(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput(
                                        controller: _restaurantNameCtrl,
                                        hintText: AppLocalizations
                                            .restaurantNamePlaceholder(),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.restaurantAddress(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput(
                                        controller: _restaurantAddressCtrl,
                                        hintText: AppLocalizations
                                            .restaurantAddressPlaceholder(),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations
                                            .restaurantDescription(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput(
                                        controller: _restaurantDescriptionCtrl,
                                        hintText: AppLocalizations
                                            .restaurantDescriptionPlaceholder(),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.restaurantPhone(),
                                        style: AppFonts.mdSemiBold,
                                      ),
                                      const SizedBox(height: 8),
                                      AppInput(
                                        controller: _restaurantPhoneCtrl,
                                        hintText: AppLocalizations
                                            .restaurantPhonePlaceholder(),
                                      ),
                                      const SizedBox(height: 20),
                                      Obx(() => AppButton(
                                            isLoading: controller.registerState
                                                .value is ResultLoading,
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                final payload =
                                                    RegisterRequestModel(
                                                  username:
                                                      _usernameCtrl.text.trim(),
                                                  name: _nameCtrl.text.trim(),
                                                  email: _emailCtrl.text.trim(),
                                                  password:
                                                      _passwordCtrl.text.trim(),
                                                  restaurant: RestaurantModel(
                                                    name: _restaurantNameCtrl
                                                        .text
                                                        .trim(),
                                                    address:
                                                        _restaurantAddressCtrl
                                                            .text
                                                            .trim(),
                                                    description:
                                                        _restaurantDescriptionCtrl
                                                            .text
                                                            .trim(),
                                                    phone: _restaurantPhoneCtrl
                                                        .text
                                                        .trim(),
                                                  ),
                                                );

                                                await controller
                                                    .register(payload);

                                                controller.registerState.value
                                                    .when(
                                                  initial: () {},
                                                  loading: () {},
                                                  success: (data) {
                                                    Get.snackbar(
                                                      AppLocalizations
                                                          .success(),
                                                      'Register success!',
                                                    );
                                                    Get.offNamed(
                                                        AppRoutes.login);
                                                  },
                                                  failed: (message) {
                                                    Get.snackbar(
                                                      AppLocalizations.error(),
                                                      message ??
                                                          'Register failed!',
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            text: AppLocalizations.register(),
                                            backgroundColor: AppColors.green,
                                            textColor: Colors.white,
                                          )),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations
                                                .alreadyHaveAccount(),
                                            style: AppFonts.smRegular.copyWith(
                                                color: AppColors.grey),
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () {
                                              Get.offNamed(AppRoutes.login);
                                            },
                                            child: Text(
                                              AppLocalizations.loginAction(),
                                              style: AppFonts.smBold.copyWith(
                                                  color: AppColors.green),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
