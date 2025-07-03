import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/widgets/app_bottom_sheet.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:get/get.dart';

class AppErrorBottomSheet extends StatelessWidget {
  final String message;

  const AppErrorBottomSheet({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return AppBottomSheet(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      persistentButtons: [
        Flexible(
          child: AppButton(
            onPressed: Get.back,
            text: AppLocalizations.ok(),
          ),
        ),
      ],
      children: [
        Icon(
          Icons.warning_rounded,
          color: colorScheme.error,
          size: 150,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: AppFonts.lgMedium,
          ),
        ),
      ],
    );
  }
}
