import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/dummy_data/dummy_user.dart';

class LoginController extends GetxController {
  final AuthRepository _repository;

  LoginController(this._repository);

  @override
  void dispose() {
    unameCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  final unameCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final loginState = Rx<ResultState<TokenModel>>(const ResultState.initial());

  Future<void> login({
    Function(String message)? onFailed,
    Function(TokenModel data)? onSuccess,
  }) async {
    if (formKey.currentState?.validate() == false) return;
    loginState.value = const ResultState.loading();

    final username = unameCtrl.text.trim();
    final password = passCtrl.text.trim();

    final user = dummyUsers.firstWhereOrNull(
      (u) => u.username == username && u.password == password,
    );

    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading

    if (user == null) {
      loginState.value = const ResultState.failed();
      onFailed?.call('Username atau password salah');
      return;
    }

    // Simulasi token dummy
    final token = TokenModel(
      accessToken: 'dummy_access_token',
      refreshToken: 'dummy_refresh_token',
    );
    loginState.value = ResultState.success(token);
    onSuccess?.call(token);
  }
}
