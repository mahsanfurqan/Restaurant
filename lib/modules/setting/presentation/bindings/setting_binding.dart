import 'package:flutter_boilerplate/modules/setting/presentation/controllers/setting_controller.dart';
import 'package:get/get.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController(Get.find()));
  }
}
