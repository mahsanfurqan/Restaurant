import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/user/data/repositories/user_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';

class SettingsController extends GetxController {
  var userFullName = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  final isDarkTheme = false.obs;
  var currentLanguage = 'id'.obs;
  var isLoggedIn = true.obs;

  final ThemeController themeCtrl = Get.find<ThemeController>();
  final AuthController authCtrl = Get.find<AuthController>();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final UserRemoteDataSource userRemoteDataSource =
      Get.find<UserRemoteDataSource>();
  final UserRepository userRepository = Get.find<UserRepository>();
  final MenuRepository menuRepository = Get.find<MenuRepository>();
  var restaurant = Rxn<RestaurantModel>();
  final RxnString restaurantError = RxnString();
  final RxBool isRestaurantLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = themeCtrl.currentThemeMode.value == ThemeMode.dark;
    fetchUserProfile();
    fetchRestaurant();
  }

  Future<void> fetchUserProfile() async {
    try {
      final authState = authCtrl.authState.value;
      final userId = authState.maybeWhen(
        success: (data) => data.id,
        orElse: () => null,
      );
      if (userId != null) {
        final user = await userRepository.getUserById(userId);
        userEmail.value = user?.email ?? '-';
        userName.value = user?.username ?? '-';
      } else {
        userEmail.value = '-';
        userName.value = '-';
      }
    } catch (e) {
      userEmail.value = '-';
      userName.value = '-';
    }
  }

  Future<void> fetchRestaurant() async {
    isRestaurantLoading.value = true;
    restaurantError.value = null;
    try {
      final authState = authCtrl.authState.value;
      final restaurantId = authState.maybeWhen(
        success: (data) => data.restaurantId,
        orElse: () => null,
      );
      if (restaurantId != null) {
        final result = await menuRepository.getRestaurant(restaurantId);
        result.fold(
          (failure) => restaurant.value = null,
          (data) => restaurant.value = data.data,
        );
      }
    } catch (e) {
      restaurantError.value = e.toString();
    } finally {
      isRestaurantLoading.value = false;
    }
  }

  Future<bool> updateRestaurant(Map<String, dynamic> body) async {
    isRestaurantLoading.value = true;
    restaurantError.value = null;
    try {
      final authState = authCtrl.authState.value;
      final restaurantId = authState.maybeWhen(
        success: (data) => data.restaurantId,
        orElse: () => null,
      );
      if (restaurantId != null) {
        final result =
            await menuRepository.updateRestaurant(restaurantId, body);
        return result.isRight();
      }
      return false;
    } catch (e) {
      restaurantError.value = e.toString();
      return false;
    } finally {
      isRestaurantLoading.value = false;
    }
  }

  Future<bool> updateUserProfile(int id, Map<String, dynamic> body) async {
    final updatedUser = await userRepository.updateUser(id, body);
    if (updatedUser != null) {
      userFullName.value = updatedUser.name ?? '-';
      userName.value = updatedUser.username ?? '-';
      return true;
    }
    return false;
  }

  Future<void> logout({required Function() onSuccess}) async {
    try {
      await authRepository.logout();
      onSuccess();
    } catch (e) {}
  }
}
