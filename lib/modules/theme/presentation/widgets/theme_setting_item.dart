import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';

class ThemeSettingItem extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool? value)? onChanged;
  final String? subtitle;

  const ThemeSettingItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile.adaptive(
      value: value,
      onChanged: onChanged,
      checkboxShape: CircleBorder(),
      checkboxScaleFactor: 1.3,
      dense: true,
      title: Text(
        title,
        style: AppFonts.mdMedium,
      ),
      subtitle: (subtitle != null)
          ? Text(
              subtitle!,
              style: AppFonts.smRegular,
            )
          : null,
    );
  }
}
