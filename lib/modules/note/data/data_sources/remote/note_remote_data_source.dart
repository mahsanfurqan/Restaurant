import 'package:flutter_boilerplate/modules/note/data/data_sources/remote/services/note_service.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_dto.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

class NoteRemoteDataSource {
  final NoteService _service;

  const NoteRemoteDataSource(this._service);

  Future<BaseResponse<NoteModel>> create(NoteDto note) =>
      _service.createNote(note);

  Future<String> delete(int id) async {
    await _service.deleteNote(id);
    return 'Note deleted';
  }

  Future<BaseResponse<List<NoteModel>>> fetch(int page, int limit) =>
      _service.fetchNotes(page, limit);

  Future<BaseResponse<NoteModel>> getById(int id) => _service.getNoteById(id);

  Future<BaseResponse<NoteModel>> update(int id, NoteDto note) =>
      _service.updateNote(id, note);
}
