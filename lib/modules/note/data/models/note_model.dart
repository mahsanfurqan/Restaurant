import 'package:flutter_boilerplate/modules/note/data/data_sources/local/entities/note_entity.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/entities/user_entity.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/note_model.freezed.dart';
part 'generated/note_model.g.dart';

@Freezed()
class NoteModel with _$NoteModel {
  const factory NoteModel({
    final int? id,
    final String? title,
    final String? content,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final UserModel? user,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  factory NoteModel.fromEntity(NoteEntity entity, {UserEntity? user}) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: (entity.createdAt != null)
          ? DateTime.tryParse(entity.createdAt ?? '')
          : null,
      updatedAt: (entity.updatedAt != null)
          ? DateTime.tryParse(entity.updatedAt ?? '')
          : null,
      user: (user != null) ? UserModel.fromEntity(user) : null,
    );
  }
}

extension NoteModelExt on NoteModel {
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt?.toIso8601String(),
      updatedAt: updatedAt?.toIso8601String(),
      userId: user?.id ?? 0,
    );
  }
}
