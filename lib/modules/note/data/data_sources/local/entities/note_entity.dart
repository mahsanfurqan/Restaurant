import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/entities/user_entity.dart';

@Entity(tableName: 'notes', foreignKeys: [
  ForeignKey(
    childColumns: ['userId'],
    parentColumns: ['id'],
    entity: UserEntity,
    onDelete: ForeignKeyAction.cascade,
    onUpdate: ForeignKeyAction.cascade,
  )
])
class NoteEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? title;
  final String? content;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  const NoteEntity({
    this.id,
    this.title,
    this.content,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        userId,
        createdAt,
        updatedAt,
      ];
}
