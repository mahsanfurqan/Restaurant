import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/core/common/app_binding.dart';
import 'package:flutter_boilerplate/firebase_options.dart';
import 'package:flutter_boilerplate/shared/responses/error_detail_response.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

abstract class AppUtils {
  AppUtils._();

  static Future<void> initProject() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load();
    await AppBinding().dependencies();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(AppConstants.general.oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);
  }

  static String? getErrorMessage(List<ErrorDetailResponse>? errors,
      [String? attr = '']) {
    if (errors?.isEmpty == true) {
      return null;
    } else {
      final message = errors?.where((e) => e.attr == attr).firstOrNull?.detail;
      return message?.capitalize;
    }
  }

  static FormFieldValidator<String?> passwordValidator([
    String? confirmText,
    int min = 8,
  ]) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
        errorText: AppLocalizations.passwordRequiredMessage(),
      ),
      // FormBuilderValidators.minLength(
      //   min,
      //   errorText: AppLocalizations.passwordMinCharacterMessage(min),
      // ),
      // FormBuilderValidators.hasUppercaseChars(
      //   errorText: AppLocalizations.passwordUpperCaseMessage(),
      // ),
      // FormBuilderValidators.hasLowercaseChars(
      //   errorText: AppLocalizations.passwordLowerCaseMessage(),
      // ),
      // FormBuilderValidators.hasNumericChars(
      //   errorText: AppLocalizations.passwordNumberMessage(),
      // ),
      // FormBuilderValidators.hasSpecialChars(
      //   errorText: AppLocalizations.passwordSpecialCharacterMessage(),
      // ),
      (value) => (confirmText == null || value == confirmText)
          ? null
          : AppLocalizations.passwordNotMatchMessage(),
    ]);
  }
}

extension CurrencyFormat on int {
  String get toCurrencyFormat {
    return 'Rp ${toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }
}

extension ResultStateX<T> on ResultState<T> {
  T? get successOrNull =>
      maybeWhen(success: (data) => data, orElse: () => null);
}
