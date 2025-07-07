import 'package:get/get.dart';
import '../controllers/view_menu_controller.dart';

class ViewMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewMenuController>(() => ViewMenuController());
  }
}
