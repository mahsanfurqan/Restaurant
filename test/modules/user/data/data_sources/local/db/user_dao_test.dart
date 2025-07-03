import 'package:flutter_boilerplate/core/services/app_database.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/db/user_dao.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../dummy_data/dummy_objects.dart';

void main() {
  late AppDatabase database;
  late UserDao dao;

  setUp(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    dao = database.userDao;
  });

  tearDown(() async {
    await database.close();
  });

  group('findAll', () {
    tearDown(() async {
      await dao.clearAll();
    });

    test('should return a list of users from local', () async {
      // Arrange
      await dao.insertAll(tUserEntities);
      // Act
      final result = await dao.findAll();
      // Assert
      expect(result, tUserEntities);
    });
  });

  group('insertAll', () {
    test('should return list of inserted ids', () async {
      // Arrange
      final userEntities = [
        UserEntity(id: 1, name: 'User 1'),
        UserEntity(id: 2, name: 'User 2'),
      ];
      // Act
      final result = await dao.insertAll(userEntities);
      // Assert
      expect(result, [1, 2]);
    });
  });

  group('findById', () {
    tearDown(() async {
      await dao.clearAll();
    });

    test('should return a valid user by given id', () async {
      // Arrange
      final userEntities = [
        UserEntity(id: 1, username: 'username', name: 'name')
      ];
      await dao.insertAll(userEntities);
      // Act
      final result = await dao.findById(1);
      // Assert
      expect(result, tUserEntity);
    });

    test('should return null when user with given id not exists', () async {
      // Act
      final result = await dao.findById(1);
      // Assert
      expect(result, null);
    });
  });

  group('clearAll', () {
    test('should delete all users in local', () async {
      // Arrange
      await dao.insertAll(tUserEntities);
      // Act
      await dao.clearAll();
      final result = await dao.findAll();
      // Assert
      expect(result, []);
    });
  });
}
