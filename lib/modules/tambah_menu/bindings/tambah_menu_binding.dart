import 'package:get/get.dart';
import '../controllers/tambah_menu_controller.dart';

class TambahMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahMenuController>(() => TambahMenuController());
  }
}
