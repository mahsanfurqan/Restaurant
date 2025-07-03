import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/socket/data/repository/socket_repository.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final SocketRepository _socketRepository;

  ChatController(this._socketRepository);

  @override
  void onInit() {
    super.onInit();
    connect(AppConstants.general.socketUrl);
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  final messageCtrl = TextEditingController();
  final message = RxString('');

  void connect(String url) {
    _socketRepository.connect(url);
    _socketRepository.receiveMessages().listen((data) {
      message.value = data;
    });
  }

  void sendMessage() {
    final message = messageCtrl.text;
    _socketRepository.sendMessage(message);
  }

  void disconnect() {
    _socketRepository.disconnect();
  }
}
