import 'package:flutter_boilerplate/core/services/app_database.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/db/note_dao.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/db/user_dao.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../dummy_data/dummy_objects.dart';

void main() {
  late AppDatabase database;
  late UserDao userDao;
  late NoteDao noteDao;

  setUp(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    userDao = database.userDao;
    noteDao = database.noteDao;
  });

  tearDown(() async {
    await database.close();
  });

  group('findAll', () {
    tearDown(() async {
      await userDao.clearAll();
      await noteDao.clearAll();
    });

    test('should return a notes data from local', () async {
      // Arrange
      await userDao.insertAll(tUserEntities);
      await noteDao.insertAll(tNoteEntities);
      // Act
      final result = await noteDao.findAll();
      // Assert
      expect(result, tNoteEntities);
    });
  });

  group('insertAll', () {
    tearDown(() async {
      await userDao.clearAll();
      await noteDao.clearAll();
    });

    test('should return list of inserted ids', () async {
      // Arrange
      await userDao.insertAll(tUserEntities);
      await noteDao.insertAll(tNoteEntities);
      // Act
      final result = await noteDao.insertAll(tNoteEntities);
      // Assert
      expect(result, [1]);
    });
  });

  group('clearAll', () {
    tearDown(() async {
      await userDao.clearAll();
      await noteDao.clearAll();
    });

    test('should delete all notes in local', () async {
      // Arrange
      await userDao.insertAll(tUserEntities);
      await noteDao.insertAll(tNoteEntities);
      // Act
      await noteDao.clearAll();
      final result = await noteDao.findAll();
      // Assert
      expect(result, []);
    });
  });
}
