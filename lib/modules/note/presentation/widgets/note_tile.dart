import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:get/get.dart';

class NoteTile extends StatelessWidget {
  final NoteModel? note;
  final Function()? onTap;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: .1),
            blurRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
        dense: true,
        title: Text(
          note?.title ?? '-',
          style: AppFonts.lgSemiBold.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          note?.content ?? '-',
          style: AppFonts.mdRegular.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
