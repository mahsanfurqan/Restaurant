import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/user/data/repositories/user_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/services/user_service.dart';
import 'package:dio/dio.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<Dio>()) {
      Get.put(Dio());
    }
    if (!Get.isRegistered<UserService>()) {
      Get.put(UserService(Get.find<Dio>()));
    }
    if (!Get.isRegistered<UserRemoteDataSource>()) {
      Get.put(UserRemoteDataSource(Get.find<UserService>()));
    }
    if (!Get.isRegistered<UserRepository>()) {
      Get.put(UserRepository(Get.find<UserRemoteDataSource>()));
    }
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
