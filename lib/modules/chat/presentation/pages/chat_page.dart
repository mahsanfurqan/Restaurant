import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/controllers/chat_controller.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';
import 'package:get/state_manager.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppLocalizations.chat()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              AppInput(
                controller: controller.messageCtrl,
                hintText: AppLocalizations.messagePlaceholder(),
              ),
              AppButton(
                onPressed: controller.sendMessage,
                text: AppLocalizations.send(),
              ),
              Obx(
                () => Text(
                  controller.message.value,
                  style: AppFonts.mdRegular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
