import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/home/presentation/controllers/home_controller.dart';
import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_detail_controller.dart';
import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_form_controller.dart';
import 'package:flutter_boilerplate/shared/helpers/alert_dialog_helper.dart';
import 'package:flutter_boilerplate/shared/helpers/bottom_sheet_helper.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class NoteFormPage extends GetView<NoteFormController> {
  const NoteFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (result == true) {
          final noteDetailCtrl = Get.find<NoteDetailController>();
          final homeCtrl = Get.find<HomeController>();
          noteDetailCtrl.getNoteById();
          homeCtrl.onRefresh();
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              (controller.note == null)
                  ? AppLocalizations.createNote()
                  : AppLocalizations.editNote(),
            ),
          ),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Obx(
                () => AppButton(
                  isLoading: controller.saveNoteState.value is ResultLoading,
                  onPressed: () => controller.saveNote(
                    onFailed: BottomSheetHelper.showError,
                    onSuccess: (_) {
                      Get.back(result: true);
                      AlertDialogHelper.showSuccess(
                          AppLocalizations.createNoteSuccessMessage());
                    },
                  ),
                  text: AppLocalizations.save(),
                ),
              ),
            ),
          ],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.title(),
                          style: AppFonts.mdRegular.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AppInput(
                          controller: controller.titleCtrl,
                          hintText: AppLocalizations.titlePlaceholder(),
                          validator: FormBuilderValidators.required(
                            errorText: AppLocalizations.titleRequiredMessage(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.note(),
                          style: AppFonts.mdRegular.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AppInput.textarea(
                          controller: controller.contentCtrl,
                          hintText: AppLocalizations.notePlaceholder(),
                          validator: FormBuilderValidators.required(
                            errorText: AppLocalizations.noteRequiredMessage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
