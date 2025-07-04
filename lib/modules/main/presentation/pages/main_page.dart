import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/main/presentation/controllers/main_controller.dart';
import 'package:flutter_boilerplate/modules/pengaturan/pages/pengaturan_page.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/widgets/custom_navbar.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/modules/lihat_menu/pages/lihat_menu_page.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.toNamed(AppRoutes.pengaturan);
          }
        },
      ),
      body: SafeArea(
        child: LihatMenuPage(),
      ),
    );
  }
}
