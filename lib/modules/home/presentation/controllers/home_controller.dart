import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/modules/note/data/repositories/note_repository.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NoteRepository _noteRepository;

  HomeController(this._noteRepository);

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchNotes();
  }

  int? page = 1;
  int limit = 10;

  final notesState =
      Rx<ResultState<List<NoteModel>>>(const ResultState.initial());

  Future<void> onRefresh() async {
    await fetchNotes(refresh: true);
  }

  Future<void> onLoadMore() async {
    await fetchNotes(loadMore: true);
  }

  Future<void> fetchNotes({bool refresh = false, bool loadMore = false}) async {
    page = refresh ? 1 : page;
    if (page == null) return;

    if (page == 1) {
      notesState.value = const ResultState.loading();
    }

    final result = await _noteRepository.fetchNotes(
      refresh: refresh,
      loadMore: loadMore,
      page: page,
      limit: limit,
    );
    result.fold((failure) {
      final message = AppUtils.getErrorMessage(failure.error?.errors);
      notesState.value = ResultState.failed(message ?? '');
    }, (data) {
      page = (data.length < limit) ? null : page! + 1;

      if (data.isEmpty) {
        if (refresh) {
          notesState.value = const ResultState.initial();
          return;
        }
        notesState.value = ResultState.success(data);
      } else {
        final currentState = notesState.value;
        notesState.value = ResultState.success(
          (currentState is ResultSuccess<List<NoteModel>>)
              ? [...currentState.data, ...data]
              : data,
        );
      }
    });
  }
}
