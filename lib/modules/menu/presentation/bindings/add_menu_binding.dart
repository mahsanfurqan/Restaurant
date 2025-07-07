import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/remote/menu_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/remote/services/menu_service.dart';
import 'package:get/get.dart';
import '../controllers/add_menu_controller.dart';

class AddMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMenuController>(() => AddMenuController());
    Get.lazyPut(() => MenuService(Get.find<Dio>()));
    Get.lazyPut(() => MenuRemoteDataSource(Get.find<MenuService>()));
  }
}
