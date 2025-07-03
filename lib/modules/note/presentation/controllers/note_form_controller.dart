import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_dto.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/modules/note/data/repositories/note_repository.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';

class NoteFormController extends GetxController {
  final NoteRepository _repository;

  NoteFormController(this._repository);

  @override
  void onInit() {
    super.onInit();

    if (note != null) {
      titleCtrl.text = note!.title ?? '';
      contentCtrl.text = note!.content ?? '';
    }
  }

  NoteModel? note = Get.arguments as NoteModel?;

  final formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  final saveNoteState = Rx<ResultState<bool>>(const ResultState.initial());

  Future<void> saveNote({
    Function(String message)? onFailed,
    Function(bool success)? onSuccess,
  }) async {
    if (formKey.currentState?.validate() == false) return;
    saveNoteState.value = ResultLoading();

    final dto = NoteDto(
      title: titleCtrl.text.trim(),
      content: contentCtrl.text.trim(),
    );

    final result = (note == null && note?.id == null)
        ? await _repository.createNote(dto)
        : await _repository.updateNote(note?.id ?? 0, dto);
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      saveNoteState.value = ResultFailed();
      onFailed?.call(message ?? '');
    }, (data) {
      saveNoteState.value = ResultSuccess(true);
      onSuccess?.call(true);
    });
  }
}
