import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_form_controller.dart';
import 'package:get/get.dart';

class NoteFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoteFormController(Get.find()));
  }
}
