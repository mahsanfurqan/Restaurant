import 'package:get/get.dart';
import '../controllers/lihat_menu_controller.dart';

class LihatMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LihatMenuController>(() => LihatMenuController());
  }
}
