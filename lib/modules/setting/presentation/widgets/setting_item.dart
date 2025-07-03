import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:get/get.dart';

class SettingItem extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final Color? textColor;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const SettingItem({
    super.key,
    required this.label,
    this.trailing,
    this.textColor,
    this.height,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Container(
      height: height ?? 50,
      width: width,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 16,
          ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.dividerColor,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.mdMedium.copyWith(
              color: textColor ?? colorScheme.onSurface,
            ),
          ),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }
}
