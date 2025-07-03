import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/modules/connectivity/presentation/widgets/no_internet_bottom_sheet.dart';
import 'package:flutter_boilerplate/shared/widgets/app_error_bottom_sheet.dart';
import 'package:get/get.dart';

abstract class BottomSheetHelper {
  static Future<T?> _showBottomSheet<T>(
    Widget child, {
    bool enableDrag = true,
    bool isDismissible = true,
  }) {
    return Get.bottomSheet(
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      isScrollControlled: true,
      child,
    );
  }

  static Future<T?> showError<T>(String message) {
    return _showBottomSheet(AppErrorBottomSheet(message: message));
  }

  static Future<T?> showNoInternetBottomSheet<T>() {
    return _showBottomSheet(
      enableDrag: false,
      isDismissible: false,
      const NoInternetBottomSheet(),
    );
  }
}
