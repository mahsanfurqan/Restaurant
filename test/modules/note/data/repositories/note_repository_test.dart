import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/note/data/repositories/note_repository.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late NoteRepository repository;
  late MockNoteRemoteDataSource mockRemoteDataSource;
  late MockNoteLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockNoteRemoteDataSource();
    mockLocalDataSource = MockNoteLocalDataSource();
    repository = NoteRepository(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('createNote', () {
    test('should return note when success', () async {
      // Arrange
      when(mockRemoteDataSource.create(tNoteDto)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModel),
      );
      when(mockLocalDataSource.clearAll()).thenAnswer(
        (_) async => 'Notes cleared',
      );
      // Act
      final result = await repository.createNote(tNoteDto);
      // Assert
      expect(result, Right(BaseResponse(data: tNoteModel)));
    });

    test('should return ServerFailure when failed', () async {
      // Arrange
      when(mockRemoteDataSource.create(tNoteDto)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tBaseErrorResponse,
        ),
      );
      // Act
      final result = await repository.createNote(tNoteDto);
      // Assert
      expect(result, Left(ServerFailure(tBaseErrorResponse)));
    });
  });

  group('deleteNote', () {
    test('should return success message when success', () async {
      // Arrange
      when(mockRemoteDataSource.delete(tNoteModel.id!)).thenAnswer(
        (_) async => 'Note deleted',
      );
      when(mockLocalDataSource.clearAll()).thenAnswer(
        (_) async => 'Notes cleared',
      );
      // Act
      final result = await repository.deleteNote(tNoteModel.id!);
      // Assert
      expect(result, Right('Note deleted'));
    });

    test('should return ServerFailure when failed', () async {
      // Arrange
      when(mockRemoteDataSource.delete(tNoteModel.id!)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tBaseErrorResponse,
        ),
      );
      // Act
      final result = await repository.deleteNote(tNoteModel.id!);
      // Assert
      expect(result, Left(ServerFailure(tBaseErrorResponse)));
    });
  });

  group('fetchNotes', () {
    const testPage = 1;
    const testLimit = 10;

    test(
        'should return notes from local when data exists and not refreshing or loading more',
        () async {
      // Arrange
      when(mockLocalDataSource.findAll()).thenAnswer((_) async => tNoteModels);
      // Act
      final result = await repository.fetchNotes();
      // Assert
      verify(mockLocalDataSource.findAll());
      verifyNever(mockRemoteDataSource.fetch(testPage, testLimit));
      expect(result, Right(tNoteModels));
    });

    test('should return notes from remote when refreshing', () async {
      // Arrange
      when(mockLocalDataSource.findAll()).thenAnswer((_) async => tNoteModels);
      when(mockRemoteDataSource.fetch(testPage, testLimit))
          .thenAnswer((_) async => BaseResponse(data: tNoteModels));
      when(mockLocalDataSource.clearAll())
          .thenAnswer((_) async => 'Notes cleared');
      when(mockLocalDataSource.insertAll(tNoteModels))
          .thenAnswer((_) async => 'Notes inserted');
      // Act
      final result = await repository.fetchNotes(refresh: true);
      // Assert
      verify(mockRemoteDataSource.fetch(testPage, testLimit));
      verify(mockLocalDataSource.clearAll());
      verify(mockLocalDataSource.insertAll(tNoteModels));
      expect(result, Right(tNoteModels));
    });

    test('should return notes from remote when loading more', () async {
      // Arrange
      when(mockLocalDataSource.findAll()).thenAnswer((_) async => tNoteModels);
      when(mockRemoteDataSource.fetch(testPage, testLimit))
          .thenAnswer((_) async => BaseResponse(data: tNoteModels));
      // Act
      final result = await repository.fetchNotes(loadMore: true);
      // Assert
      verify(mockRemoteDataSource.fetch(testPage, testLimit));
      expect(result, Right(tNoteModels));
    });

    test('should return notes from remote when cache is empty', () async {
      // Arrange
      when(mockLocalDataSource.findAll()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.fetch(testPage, testLimit))
          .thenAnswer((_) async => BaseResponse(data: tNoteModels));
      // Act
      final result = await repository.fetchNotes();
      // Assert
      verify(mockRemoteDataSource.fetch(testPage, testLimit));
      expect(result, Right(tNoteModels));
    });

    test('should return notes from remote with custom limit', () async {
      // Arrange
      when(mockLocalDataSource.findAll()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.fetch(testPage, 20)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModels),
      );
      // Act
      final result = await repository.fetchNotes(limit: 20);
      // Assert
      verify(mockRemoteDataSource.fetch(testPage, 20));
      expect(result, Right(tNoteModels));
    });

    test('should return ServerFailure when failed', () async {
      // Arrange
      when(mockLocalDataSource.findAll()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.fetch(testPage, testLimit)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tBaseErrorResponse,
        ),
      );
      // Act
      final result = await repository.fetchNotes();
      // Assert
      expect(result, Left(ServerFailure(tBaseErrorResponse)));
    });
  });

  group('getNoteById', () {
    test('should return note with given id when success', () async {
      // Arrange
      when(mockRemoteDataSource.getById(tNoteModel.id!)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModel),
      );
      // Act
      final result = await repository.getNoteById(tNoteModel.id!);
      // Assert
      expect(result, Right(BaseResponse(data: tNoteModel)));
    });

    test('should return ServerFailure when failed', () async {
      // Arrange
      when(mockRemoteDataSource.getById(tNoteModel.id!)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tBaseErrorResponse,
        ),
      );
      // Act
      final result = await repository.getNoteById(tNoteModel.id!);
      // Assert
      expect(result, Left(ServerFailure(tBaseErrorResponse)));
    });
  });

  group('updateNote', () {
    test('should return updated note when success', () async {
      // Arrange
      when(mockRemoteDataSource.update(tNoteModel.id!, tNoteDto)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModel),
      );
      when(mockLocalDataSource.clearAll())
          .thenAnswer((_) async => 'Notes cleared');
      // Act
      final result = await repository.updateNote(tNoteModel.id!, tNoteDto);
      // Assert
      expect(result, Right(BaseResponse(data: tNoteModel)));
    });

    test('should return ServerFailure when failed', () async {
      // Arrange
      when(mockRemoteDataSource.update(tNoteModel.id!, tNoteDto)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: tBaseErrorResponse,
        ),
      );
      // Act
      final result = await repository.updateNote(tNoteModel.id!, tNoteDto);
      // Assert
      expect(result, Left(ServerFailure(tBaseErrorResponse)));
    });
  });
}
