import 'package:flutter_boilerplate/modules/auth/presentation/bindings/auth_binding.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/pages/login_page.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/pages/register_page.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/bindings/chat_binding.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/pages/chat_page.dart';
import 'package:flutter_boilerplate/modules/main/presentation/bindings/main_binding.dart';
import 'package:flutter_boilerplate/modules/main/presentation/pages/main_page.dart';
import 'package:flutter_boilerplate/modules/note/presentation/bindings/note_detail_binding.dart';
import 'package:flutter_boilerplate/modules/note/presentation/bindings/note_form_binding.dart';
import 'package:flutter_boilerplate/modules/note/presentation/pages/note_detail_page.dart';
import 'package:flutter_boilerplate/modules/note/presentation/pages/note_form_page.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/pages/theme_page.dart';
import 'package:flutter_boilerplate/modules/lihat_menu/lihat_menu_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.main;

  static final pages = [
    GetPage(
      name: _Paths.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.noteDetail,
      page: () => const NoteDetailPage(),
      binding: NoteDetailBinding(),
    ),
    GetPage(
      name: _Paths.noteForm,
      page: () => const NoteFormPage(),
      binding: NoteFormBinding(),
    ),
    GetPage(
      name: _Paths.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.displayMode,
      page: () => const ThemePage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.lihatMenu,
      page: () => const LihatMenuPage(),
    ),
  ];
}
