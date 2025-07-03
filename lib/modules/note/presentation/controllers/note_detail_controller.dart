import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/modules/note/data/repositories/note_repository.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';

class NoteDetailController extends GetxController {
  final NoteRepository _repository;

  NoteDetailController(this._repository);

  @override
  Future<void> onInit() async {
    await getNoteById();
    super.onInit();
  }

  int? id = Get.arguments as int?;

  final noteState = Rx<ResultState<NoteModel>>(const ResultState.initial());
  final deleteNoteState = Rx<ResultState<String>>(const ResultState.initial());

  Future<void> getNoteById() async {
    noteState.value = const ResultState.loading();

    final result = await _repository.getNoteById(id ?? 0);
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      noteState.value = ResultState.failed(message ?? '');
    }, (data) {
      noteState.value = ResultState.success(data.data!);
    });
  }

  Future<void> deleteNote({
    Function()? onLoading,
    Function(String message)? onFailed,
    Function(String data)? onSuccess,
  }) async {
    deleteNoteState.value = const ResultState.loading();
    onLoading?.call();

    final result = await _repository.deleteNote(id ?? 0);
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      deleteNoteState.value = ResultState.failed(message ?? '');
      onFailed?.call(message ?? '');
    }, (data) {
      deleteNoteState.value = ResultState.success(data);
      onSuccess?.call(data);
    });
  }
}
