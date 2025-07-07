import 'package:flutter_boilerplate/modules/auth/presentation/bindings/auth_binding.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/pages/login_page.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/pages/register_page.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/pages/splash_page.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/bindings/chat_binding.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/pages/chat_page.dart';
import 'package:flutter_boilerplate/modules/main/presentation/bindings/main_binding.dart';
import 'package:flutter_boilerplate/modules/main/presentation/pages/main_page.dart';
import 'package:flutter_boilerplate/modules/note/presentation/bindings/note_detail_binding.dart';
import 'package:flutter_boilerplate/modules/note/presentation/bindings/note_form_binding.dart';
import 'package:flutter_boilerplate/modules/note/presentation/pages/note_detail_page.dart';
import 'package:flutter_boilerplate/modules/note/presentation/pages/note_form_page.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/pages/theme_page.dart';
import 'package:flutter_boilerplate/modules/menu/presentation/pages/view_menu_page.dart';
import 'package:flutter_boilerplate/modules/menu/presentation/pages/add_menu_page.dart';
import 'package:flutter_boilerplate/modules/menu/presentation/bindings/add_menu_binding.dart';
import 'package:flutter_boilerplate/modules/menu/presentation/bindings/view_menu_binding.dart';
import 'package:flutter_boilerplate/modules/settings/pages/settings_page.dart';
import 'package:flutter_boilerplate/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.main;

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.noteDetail,
      page: () => const NoteDetailPage(),
      binding: NoteDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.noteForm,
      page: () => const NoteFormPage(),
      binding: NoteFormBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.displayMode,
      page: () => const ThemePage(),
    ),
    GetPage(
      name: AppRoutes.viewMenu,
      page: () => const ViewMenuPage(),
      binding: ViewMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.addMenu,
      page: () => AddMenuPage(),
      binding: AddMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SettingsController>(() => SettingsController());
      }),
    ),
  ];
}
