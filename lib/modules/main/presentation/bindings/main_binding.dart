import 'package:flutter_boilerplate/modules/chat/presentation/bindings/chat_binding.dart';
import 'package:flutter_boilerplate/modules/home/presentation/bindings/home_binding.dart';
import 'package:flutter_boilerplate/modules/main/presentation/controllers/main_controller.dart';
import 'package:flutter_boilerplate/modules/setting/presentation/bindings/setting_binding.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());

    HomeBinding().dependencies();
    ChatBinding().dependencies();
    SettingBinding().dependencies();
  }
}
