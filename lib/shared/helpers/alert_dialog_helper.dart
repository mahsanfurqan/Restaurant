import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_boilerplate/shared/utils/app_enums.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/widgets/app_alert_dialog.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AlertDialogHelper {
  static Future<dynamic> _showDialog({
    required AppAlertType type,
    String? title,
    String? message,
    String? confirmBtnText,
    String? cancelBtnText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancelBtn = false,
  }) {
    return Get.dialog(
      AppAlertDialog(
        type: type,
        title: title,
        text: message,
        confirmBtnText: confirmBtnText,
        cancelBtnText: cancelBtnText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showCancelBtn: showCancelBtn,
      ),
      barrierDismissible: type != AppAlertType.loading,
    );
  }

  static Future<dynamic> _showConfirmDialog({
    required String title,
    required String message,
    String? confirmBtnText,
    String? cancelBtnText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return _showDialog(
      type: AppAlertType.confirm,
      confirmBtnText: confirmBtnText ?? AppLocalizations.yes(),
      cancelBtnText: cancelBtnText ?? AppLocalizations.cancel(),
      title: title,
      message: message,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  static Future<dynamic> showGalleryPermission() {
    final permission = AppPermissionAlertType.gallery.name.capitalize ?? '';
    final title = AppLocalizations.requestPermissionTitle(
      AppConstants.general.appName,
      permission,
    );

    return _showConfirmDialog(
      confirmBtnText: AppLocalizations.yes(),
      cancelBtnText: AppLocalizations.cancel(),
      onConfirm: openAppSettings,
      title: title,
      message: AppLocalizations.permissionMessage(),
    );
  }

  static Future<dynamic> showCameraPermission() {
    final permission = AppPermissionAlertType.camera.name.capitalize ?? '';
    final title = AppLocalizations.requestPermissionTitle(
      AppConstants.general.appName,
      permission,
    );

    return _showConfirmDialog(
      confirmBtnText: AppLocalizations.yes(),
      cancelBtnText: AppLocalizations.cancel(),
      onConfirm: openAppSettings,
      title: title,
      message: AppLocalizations.permissionMessage(),
    );
  }

  static Future<dynamic> showLoading() {
    return _showDialog(
      type: AppAlertType.loading,
      title: AppLocalizations.loading(),
      message: AppLocalizations.loggingOut(),
    );
  }

  static Future<dynamic> showCreateNoteSuccess() {
    return _showDialog(
      type: AppAlertType.success,
      title: AppLocalizations.successTitle(),
      message: AppLocalizations.createNoteSuccessMessage(),
    );
  }

  static Future<dynamic> showSuccessDialog({
    String? title,
    String? message,
  }) {
    return _showDialog(
      type: AppAlertType.success,
      title: title ?? AppLocalizations.successTitle(),
      message: message ?? AppLocalizations.createMenuSuccessMessage(),
    );
  }

  static Future<dynamic> showLogout({required VoidCallback onConfirm}) {
    return _showConfirmDialog(
      confirmBtnText: AppLocalizations.yes(),
      cancelBtnText: AppLocalizations.cancel(),
      title: AppLocalizations.logoutTitle(),
      message: AppLocalizations.logoutMessage(),
      onConfirm: onConfirm,
    );
  }

  static Future<dynamic> showDeleteNoteConfirmation({
    required VoidCallback onConfirm,
  }) {
    return _showConfirmDialog(
      confirmBtnText: AppLocalizations.yes(),
      cancelBtnText: AppLocalizations.cancel(),
      title: AppLocalizations.deleteNote(),
      message: AppLocalizations.deleteNoteConfirmationMessage(),
      onConfirm: onConfirm,
    );
  }

  static Future<dynamic> showDeleteNoteSuccess() {
    return _showDialog(
      type: AppAlertType.success,
      title: AppLocalizations.successTitle(),
      message: AppLocalizations.deleteNoteSuccessMessage(),
    );
  }

  static Future<dynamic> showEditMenuSuccess() {
    return showSuccessDialog(
      title: AppLocalizations.successTitle(),
      message: AppLocalizations.editMenuSuccess(),
    );
  }

  static Future<dynamic> showDeleteMenuSuccess() {
    return showSuccessDialog(
      title: AppLocalizations.successTitle(),
      message: AppLocalizations.deleteMenuSuccess(),
    );
  }

  static Future<dynamic> showEditMenuFailed() {
    return _showDialog(
      type: AppAlertType.error,
      title: AppLocalizations.error(),
      message: AppLocalizations.editMenuFailed(),
    );
  }

  static Future<dynamic> showDeleteMenuFailed() {
    return _showDialog(
      type: AppAlertType.error,
      title: AppLocalizations.error(),
      message: AppLocalizations.deleteMenuFailed(),
    );
  }

  static Future<dynamic> showRegisterSuccess() {
    return _showDialog(
      type: AppAlertType.success,
      title: AppLocalizations.successTitle(),
      message: AppLocalizations.createMenuSuccessMessage(),
    );
  }

  static Future<dynamic> showRegisterFailed({String? message}) {
    return _showDialog(
      type: AppAlertType.error,
      title: AppLocalizations.error(),
      message: message ?? 'Register failed!',
    );
  }
}
