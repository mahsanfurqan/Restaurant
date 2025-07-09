import 'dart:async';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_request_model.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:dartz/dartz.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;

  AuthController(this._repository);

  @override
  Future<void> onInit() async {
    super.onInit();
    authState.value = const ResultState.loading();

    // Add delay to ensure everything is initialized
    await Future.delayed(const Duration(milliseconds: 500));
    await authCheck();
  }

  final authState =
      Rx<ResultState<AuthValidateModel>>(const ResultState.loading());
  final loggedInUsername = ''.obs;
  final registerState = Rx<ResultState<bool>>(const ResultState.initial());

  Future<void> authCheck({bool forceValidate = false}) async {
    try {
      Either<Failure, AuthValidateModel> result;
      if (forceValidate) {
        result = await _repository.validateAuth();
      } else {
        result = await _repository.quickAuthCheck();
      }
      result.fold((failure) {
        authState.value = const ResultState.failed();
      }, (data) {
        authState.value = ResultState.success(data);
      });
    } catch (e) {
      authState.value = const ResultState.failed();
    }
  }

  void setLoggedInUsername(String username) {
    loggedInUsername.value = username;
  }

  Future<void> register(RegisterRequestModel payload) async {
    registerState.value = const ResultState.loading();
    final result = await _repository.register(payload);
    result.fold(
      (failure) => registerState.value = ResultState.failed(failure.message),
      (data) => registerState.value = const ResultState.success(true),
    );
  }
}
