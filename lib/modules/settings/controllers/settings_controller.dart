import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';

class SettingsController extends GetxController {
  var userFullName = ''.obs;
  var userName = ''.obs;
  final isDarkTheme = false.obs;
  var currentLanguage = 'id'.obs;
  var isLoggedIn = true.obs;

  final ThemeController themeCtrl = Get.find<ThemeController>();
  final AuthController authCtrl = Get.find<AuthController>();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final UserRemoteDataSource userRemoteDataSource =
      Get.find<UserRemoteDataSource>();

  @override
  void onInit() {
    super.onInit();
    print('DEBUG: loggedInUsername = ${authCtrl.loggedInUsername.value}');
    isDarkTheme.value = themeCtrl.currentThemeMode.value == ThemeMode.dark;
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final user = await userRemoteDataSource.getMe();
      userFullName.value = user.name;
      userName.value = user.username;
    } catch (e) {
      userFullName.value = '-';
      userName.value = '-';
    }
  }

  Future<void> logout({required Function() onSuccess}) async {
    try {
      await authRepository.logout();
      onSuccess();
    } catch (e) {
      // Handle error if needed
      print('Logout error: $e');
    }
  }
}
