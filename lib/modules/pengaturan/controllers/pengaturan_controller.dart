import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/shared/dummy_data/dummy_user.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';

class PengaturanController extends GetxController {
  var userFullName = ''.obs;
  var userName = ''.obs;
  final isDarkTheme = false.obs;
  var currentLanguage = 'id'.obs;
  var isLoggedIn = true.obs;

  final ThemeController themeCtrl = Get.find<ThemeController>();
  final AuthController authCtrl = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = themeCtrl.currentThemeMode.value == ThemeMode.dark;
    ever(authCtrl.loggedInUsername, (uname) {
      final dummy = dummyUsers.where((u) => u.username == uname).toList();
      userName.value = dummy.isNotEmpty ? dummy.first.username : '-';
      userFullName.value = dummy.isNotEmpty ? dummy.first.fullName : '-';
    });
    final uname = authCtrl.loggedInUsername.value;
    final dummy = dummyUsers.where((u) => u.username == uname).toList();
    userName.value = dummy.isNotEmpty ? dummy.first.username : '-';
    userFullName.value = dummy.isNotEmpty ? dummy.first.fullName : '-';
  }
}
