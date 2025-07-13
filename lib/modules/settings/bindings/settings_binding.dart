import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/settings/data/repositories/settings_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/repositories/user_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/services/user_service.dart';
import 'package:dio/dio.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Dio
    Get.lazyPut<Dio>(() => Dio());
    // Inject UserService, UserRemoteDataSource, UserRepository
    Get.lazyPut<UserService>(() => UserService(Get.find<Dio>()));
    Get.lazyPut<UserRemoteDataSource>(
        () => UserRemoteDataSource(Get.find<UserService>()));
    Get.lazyPut<UserRepository>(
        () => UserRepository(Get.find<UserRemoteDataSource>()));

    Get.lazyPut<SettingsRepository>(() => SettingsRepository(
          Get.find(), // AuthRepository
          Get.find(), // UserRepository
          Get.find(), // MenuRepository
        ));

    Get.lazyPut<SettingsController>(() => SettingsController(
          Get.find<ThemeController>(),
          Get.find<AuthController>(),
          Get.find<SettingsRepository>(),
        ));
  }
}
