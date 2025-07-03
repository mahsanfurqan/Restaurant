import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_detail_controller.dart';
import 'package:flutter_boilerplate/shared/helpers/alert_dialog_helper.dart';
import 'package:flutter_boilerplate/shared/helpers/bottom_sheet_helper.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/widgets/app_refresher.dart';
import 'package:flutter_boilerplate/shared/widgets/app_skeletonizer.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteDetailPage extends GetView<NoteDetailController> {
  const NoteDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.note()),
        actions: [
          Obx(() {
            final noteState = controller.noteState.value;
            final note = noteState.maybeWhen(
              orElse: () => null,
              success: (data) => data,
            );
            return IconButton(
              onPressed: () {
                if (note != null) {
                  Get.toNamed(
                    AppRoutes.noteForm,
                    arguments: note,
                  );
                }
              },
              icon: Icon(
                Icons.edit,
                color: colorScheme.onSurface,
                size: 22,
              ),
            );
          }),
          IconButton(
            onPressed: () => AlertDialogHelper.showDeleteNoteConfirmation(
              onConfirm: () {
                Get.back();
                controller.deleteNote(
                  onLoading: AlertDialogHelper.showLoading,
                  onFailed: (message) {
                    Get.back(closeOverlays: true);
                    BottomSheetHelper.showError(message);
                  },
                  onSuccess: (_) {
                    Get.back();

                    Get.offAndToNamed(AppRoutes.main, result: true);
                    AlertDialogHelper.showDeleteNoteSuccess();
                  },
                );
              },
            ),
            icon: Icon(
              Icons.delete_forever_rounded,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: AppRefresher(
            onRefresh: () async {
              controller.getNoteById();
            },
            child: Obx(
              () => controller.noteState.value.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                loading: () => const AppSkeletonizer(
                  enabled: true,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Bone.text(),
                        SizedBox(height: 4),
                        Bone.text(),
                      ],
                    ),
                  ),
                ),
                success: (data) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title ?? '-',
                          style: AppFonts.lgSemiBold.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data.content ?? '-',
                          style: AppFonts.mdRegular.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
