import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/settings/data/repositories/settings_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';

class SettingsController extends GetxController {
  final ThemeController _themeController;
  final AuthController _authController;
  final SettingsRepository _settingsRepository;

  SettingsController(
    this._themeController,
    this._authController,
    this._settingsRepository,
  );

  // State for user profile
  final Rx<ResultState<Map<String, String>>> userProfileState =
      const ResultState<Map<String, String>>.initial().obs;
  // State for restaurant
  final Rx<ResultState<RestaurantModel>> restaurantState =
      const ResultState<RestaurantModel>.initial().obs;
  // State for update user
  final Rx<ResultState<bool>> updateUserState =
      const ResultState<bool>.initial().obs;
  // State for update restaurant
  final Rx<ResultState<bool>> updateRestaurantState =
      const ResultState<bool>.initial().obs;

  final RxBool _isDarkTheme = false.obs;
  final RxString _currentLanguage = 'id'.obs;
  final RxBool _isLoggedIn = true.obs;

  @override
  void onInit() {
    super.onInit();
    _isDarkTheme.value =
        _themeController.currentThemeMode.value == ThemeMode.dark;
    fetchUserProfile();
    fetchRestaurant();
  }

  void fetchUserProfile() async {
    userProfileState.value = const ResultState.loading();
    try {
      final authState = _authController.authState.value;
      final userId = authState.maybeWhen(
        success: (data) => data.id,
        orElse: () => null,
      );
      if (userId != null) {
        final result = await _settingsRepository.getUserById(userId);
        result.fold(
          (failure) => userProfileState.value = ResultState.failed(
              AppUtils.getErrorMessage(failure.error?.errors)),
          (user) => userProfileState.value = ResultState.success({
            'email': user?.email ?? '-',
            'username': user?.username ?? '-',
          }),
        );
      } else {
        userProfileState.value = ResultState.success({
          'email': '-',
          'username': '-',
        });
      }
    } catch (e) {
      userProfileState.value = ResultState.failed(e.toString());
    }
  }

  void fetchRestaurant() async {
    restaurantState.value = const ResultState.loading();
    try {
      final authState = _authController.authState.value;
      final restaurantId = authState.maybeWhen(
        success: (data) => data.restaurantId,
        orElse: () => null,
      );
      if (restaurantId != null) {
        final result = await _settingsRepository.getRestaurant(restaurantId);
        result.fold(
          (failure) => restaurantState.value = ResultState.failed(
              AppUtils.getErrorMessage(failure.error?.errors)),
          (data) {
            if (data != null) {
              restaurantState.value = ResultState.success(data);
            } else {
              restaurantState.value = ResultState.failed('No restaurant data');
            }
          },
        );
      } else {
        restaurantState.value = ResultState.failed('No restaurant ID');
      }
    } catch (e) {
      restaurantState.value = ResultState.failed(e.toString());
    }
  }

  Future<void> updateUserProfile(int id, Map<String, dynamic> body) async {
    updateUserState.value = const ResultState.loading();
    final result = await _settingsRepository.updateUserProfile(id, body);
    result.fold(
      (failure) => updateUserState.value =
          ResultState.failed(AppUtils.getErrorMessage(failure.error?.errors)),
      (updatedUser) {
        if (updatedUser != null) {
          updateUserState.value = const ResultState.success(true);
          fetchUserProfile();
        } else {
          updateUserState.value = ResultState.failed('Update failed');
        }
      },
    );
  }

  Future<void> updateRestaurant(Map<String, dynamic> body) async {
    updateRestaurantState.value = const ResultState.loading();
    final authState = _authController.authState.value;
    final restaurantId = authState.maybeWhen(
      success: (data) => data.restaurantId,
      orElse: () => null,
    );
    if (restaurantId != null) {
      final result =
          await _settingsRepository.updateRestaurant(restaurantId, body);
      result.fold(
        (failure) => updateRestaurantState.value =
            ResultState.failed(AppUtils.getErrorMessage(failure.error?.errors)),
        (data) {
          updateRestaurantState.value = const ResultState.success(true);
          fetchRestaurant();
        },
      );
    } else {
      updateRestaurantState.value = ResultState.failed('No restaurant ID');
    }
  }

  Future<void> logout({required Function() onSuccess}) async {
    final result = await _settingsRepository.logout();
    result.fold(
      (failure) {
        // Handle logout failure
      },
      (success) {
        onSuccess();
      },
    );
  }

  // Getters for public access
  RxBool get isDarkTheme => _isDarkTheme;
  RxString get currentLanguage => _currentLanguage;
  RxBool get isLoggedIn => _isLoggedIn;
  AuthController get authController => _authController;
}
