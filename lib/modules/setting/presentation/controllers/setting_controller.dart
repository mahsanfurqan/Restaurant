import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final AuthRepository _repository;

  SettingController(this._repository);

  @override
  void onInit() async {
    super.onInit();
    await getActiveUser();
  }

  final userState = Rx<ResultState<UserModel>>(ResultState.initial());
  final logoutState = Rx<ResultState<bool>>(const ResultState.initial());

  Future<void> getActiveUser() async {
    userState.value = ResultState.loading();

    final result = await _repository.getActiveUser();
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      userState.value = ResultState.failed(message);
    }, (data) {
      userState.value = ResultState.success(data);
    });
  }

  Future<void> logout({
    Function()? onLoading,
    Function(String message)? onFailed,
    Function(bool data)? onSuccess,
  }) async {
    logoutState.value = const ResultState.loading();
    onLoading?.call();

    final result = await _repository.logout();
    result.fold((failure) {
      Get.back();
      final message = AppUtils.getErrorMessage(failure.error?.errors) ?? '';
      logoutState.value = const ResultState.failed();
      onFailed?.call(message);
    }, (isLoggedOut) {
      Get.back();
      if (isLoggedOut) {
        logoutState.value = ResultState.success(isLoggedOut);
        onSuccess?.call(isLoggedOut);
      }
    });
  }
}
