import 'package:flutter_boilerplate/core/common/exceptions.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/note_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late NoteLocalDataSource dataSource;
  late MockNoteDao mockNoteDao;
  late MockUserDao mockUserDao;

  setUp(() {
    mockNoteDao = MockNoteDao();
    mockUserDao = MockUserDao();
    dataSource = NoteLocalDataSource(
      mockNoteDao,
      mockUserDao,
    );
  });

  group('findAll', () {
    test('should return notes data when success', () async {
      // Arrange
      when(mockNoteDao.findAll()).thenAnswer((_) async => tNoteEntities);
      when(mockUserDao.findById(tNoteEntities[0].userId))
          .thenAnswer((_) async => tUserEntity);
      // Act
      final result = await dataSource.findAll();
      // Assert
      expect(result, tNoteModels);
    });
  });

  group('insertAll', () {
    test('should return success message when success', () async {
      // Arrange
      when(mockUserDao.insertAll(tUserEntities)).thenAnswer((_) async => [1]);
      when(mockNoteDao.insertAll(tNoteEntities)).thenAnswer((_) async => [1]);
      // Act
      final result = await dataSource.insertAll(tNoteModels);
      // Assert
      expect(result, 'Notes inserted');
    });

    test('should throw DatabaseException when user not inserted', () async {
      // Arrange
      when(mockNoteDao.insertAll(tNoteEntities)).thenThrow(Exception());
      // Act
      final call = dataSource.insertAll(tNoteModels);
      // Assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('clearAll', () {
    test('should return success message when success', () async {
      // Arrange
      when(mockNoteDao.clearAll()).thenAnswer((_) async => 1);
      // Act
      final result = await dataSource.clearAll();
      // Assert
      expect(result, 'Notes cleared');
    });

    test('should throw DatabaseException when failed', () async {
      // Arrange
      when(mockNoteDao.clearAll()).thenThrow(Exception());
      // Act
      final result = dataSource.clearAll();
      // Assert
      expect(result, throwsA(isA<DatabaseException>()));
    });
  });
}
