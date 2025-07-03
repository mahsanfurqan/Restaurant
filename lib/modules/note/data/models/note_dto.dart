import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/note_dto.freezed.dart';
part 'generated/note_dto.g.dart';

@Freezed(fromJson: false, toJson: true)
class NoteDto with _$NoteDto {
  const factory NoteDto({
    required String title,
    required String content,
  }) = _NoteDto;
}
