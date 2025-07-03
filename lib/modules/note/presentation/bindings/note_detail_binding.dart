import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_detail_controller.dart';
import 'package:get/get.dart';

class NoteDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoteDetailController(Get.find()));
  }
}
