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
import 'package:flutter_boilerplate/modules/lihat_menu/pages/lihat_menu_page.dart';
import 'package:flutter_boilerplate/modules/tambah_menu/pages/tambah_menu_page.dart';
import 'package:flutter_boilerplate/modules/tambah_menu/bindings/tambah_menu_binding.dart';
import 'package:flutter_boilerplate/modules/lihat_menu/bindings/lihat_menu_binding.dart';
import 'package:flutter_boilerplate/modules/pengaturan/pages/pengaturan_page.dart';
import 'package:flutter_boilerplate/modules/pengaturan/bindings/pengaturan_binding.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.main;

  static final pages = [
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
      name: AppRoutes.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.lihatMenu,
      page: () => const LihatMenuPage(),
      binding: LihatMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.tambahMenu,
      page: () => TambahMenuPage(),
      binding: TambahMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.pengaturan,
      page: () => PengaturanPage(),
      binding: PengaturanBinding(),
    ),
  ];
}
