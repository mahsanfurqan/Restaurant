import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/main/presentation/controllers/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/main/widgets/custom_navbar.dart';
import 'package:flutter_boilerplate/modules/menu/presentation/pages/view_menu_page.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/menu/presentation/controllers/view_menu_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject ViewMenuController manually since ViewMenuPage is used directly
    Get.lazyPut<ViewMenuController>(() => ViewMenuController());
    return Scaffold(
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.toNamed(AppRoutes.settings);
          }
        },
      ),
      body: SafeArea(
        child: ViewMenuPage(),
      ),
    );
  }
}
