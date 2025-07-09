import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository _repository;

  LoginController(this._repository);

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final loginState =
      Rx<ResultState<BaseResponse<TokenModel>>>(const ResultState.initial());

  Future<void> login({
    Function(String message)? onFailed,
    Function(TokenModel data)? onSuccess,
  }) async {
    if (formKey.currentState?.validate() == false) return;
    loginState.value = const ResultState.loading();

    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    final result =
        await _repository.login(LoginDto(email: email, password: password));
    result.fold(
      (failure) {
        final message = AppUtils.getErrorMessage(failure.error?.errors);
        loginState.value = ResultState.failed(message);
        onFailed?.call(message ?? 'Login gagal');
      },
      (response) async {
        loginState.value = ResultState.success(response);
        if (response.data != null) {
          onSuccess?.call(response.data!);
        }
        final authCtrl = Get.find<AuthController>();
        authCtrl.setLoggedInUsername(email);

        // Create auth session from token since validateAuth endpoint doesn't exist
        final authResult = await _repository.createAuthFromToken();
        authResult.fold(
          (failure) {
            print('DEBUG: Failed to create auth session: ${failure.message}');
            // Still consider login successful, just update auth state
            authCtrl.authState.value = const ResultState.failed();
          },
          (authData) {
            print('DEBUG: Auth session created successfully: ${authData.id}');
            authCtrl.authState.value = ResultState.success(authData);
          },
        );
      },
    );
  }
}
