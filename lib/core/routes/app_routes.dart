part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const main = _Paths.main;
  static const noteDetail = _Paths.noteDetail;
  static const noteForm = _Paths.noteForm;
  static const login = _Paths.login;
  static const chat = _Paths.chat;
  static const displayMode = _Paths.displayMode;
  static const String register = '/register';
  static const String viewMenu = '/view_menu';
  static const String addMenu = '/add-menu';
  static const String settings = '/settings';
  static const String splash = '/splash';
}

abstract class _Paths {
  _Paths._();

  static const main = '/';
  static const noteDetail = '/note-detail';
  static const noteForm = '/note-form';
  static const login = '/login';
  static const chat = '/chat';
  static const displayMode = '/display-mode';
  static const addMenu = '/add-menu';
  static const settings = '/settings';
  static const splash = '/splash';
}
