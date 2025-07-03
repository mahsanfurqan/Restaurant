import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/pages/chat_page.dart';
import 'package:flutter_boilerplate/modules/home/presentation/pages/home_page.dart';
import 'package:flutter_boilerplate/modules/main/presentation/controllers/main_controller.dart';
import 'package:flutter_boilerplate/modules/setting/presentation/pages/setting_page.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/widgets/custom_navbar.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => CustomNavbar(
          selectedIndex: controller.currentPage.value == 0 ? 0 : 1,
          onTap: (index) {
            if (index == 0) {
              controller.changePage(0); // Menu (HomePage)
            } else {
              controller.changePage(2); // Pengaturan (SettingPage)
            }
          },
        ),
      ),
      body: SafeArea(
        child: PageView(
          allowImplicitScrolling: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageCtrl,
          onPageChanged: controller.changePage,
          children: [
            HomePage(),
            ChatPage(),
            SettingPage(),
          ],
        ),
      ),
    );
  }
}
