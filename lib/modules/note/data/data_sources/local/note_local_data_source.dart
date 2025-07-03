import 'package:flutter_boilerplate/core/common/exceptions.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/db/note_dao.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/entities/note_entity.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/db/user_dao.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';

class NoteLocalDataSource {
  final NoteDao _dao;
  final UserDao _userDao;

  const NoteLocalDataSource(
    this._dao,
    this._userDao,
  );

  Future<List<NoteModel>> findAll() async {
    final noteEntities = (await _dao.findAll()).reversed;
    final noteModels = <NoteModel>[];

    for (var entity in noteEntities) {
      final userEntity = await _userDao.findById(entity.userId ?? 0);
      noteModels.add(NoteModel.fromEntity(entity, user: userEntity));
    }

    return noteModels;
  }

  Future<String> insertAll(List<NoteModel> notes) async {
    try {
      final users = <UserModel>{};
      final noteEntities = <NoteEntity>[];

      for (var note in notes) {
        if (note.user != null) {
          users.add(note.user!);
        }
        noteEntities.add(note.toEntity());
      }

      await _userDao.insertAll(users.map((user) => user.toEntity()).toList());
      await _dao.insertAll(noteEntities);

      return 'Notes inserted';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<String> clearAll() async {
    try {
      await _dao.clearAll();
      return 'Notes cleared';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
