import 'package:floor/floor.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/entities/note_entity.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM notes')
  Future<List<NoteEntity>> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<NoteEntity> notes);

  @Query('DELETE FROM notes')
  Future<void> clearAll();
}
