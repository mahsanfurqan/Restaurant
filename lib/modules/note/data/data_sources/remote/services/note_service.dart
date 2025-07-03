import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_boilerplate/modules/note/data/models/note_dto.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/note_service.g.dart';

@RestApi()
abstract class NoteService {
  factory NoteService(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _NoteService;

  @POST('/notes')
  Future<BaseResponse<NoteModel>> createNote(@Body() NoteDto note);

  @GET('/notes')
  Future<BaseResponse<List<NoteModel>>> fetchNotes(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/notes/{id}')
  Future<BaseResponse<NoteModel>> getNoteById(@Path() int id);

  @PATCH('/notes/{id}')
  Future<BaseResponse<NoteModel>> updateNote(
    @Path() int id,
    @Body() NoteDto note,
  );

  @DELETE('/notes/{id}')
  Future<void> deleteNote(@Path() int id);
}
