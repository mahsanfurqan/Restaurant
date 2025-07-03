import 'package:flutter_boilerplate/modules/chat/presentation/controllers/chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController(Get.find()));
  }
}
