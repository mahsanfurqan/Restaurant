import 'package:flutter_boilerplate/modules/note/data/data_sources/remote/note_remote_data_source.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late NoteRemoteDataSource dataSource;
  late MockNoteService mockNoteService;

  setUp(() {
    mockNoteService = MockNoteService();
    dataSource = NoteRemoteDataSource(
      mockNoteService,
    );
  });

  group('create', () {
    test('should return note data when success', () async {
      // Arrange
      when(mockNoteService.createNote(tNoteDto)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModel),
      );
      // Act
      final result = await dataSource.create(tNoteDto);
      // Assert
      expect(result, BaseResponse(data: tNoteModel));
    });
  });

  group('delete', () {
    const testId = 1;

    test('should return success message when success', () async {
      // Arrange
      when(mockNoteService.deleteNote(testId)).thenAnswer(
        (_) async => 'Note deleted',
      );
      // Act
      final result = await dataSource.delete(testId);
      // Assert
      expect(result, 'Note deleted');
    });
  });

  group('fetch', () {
    const testPage = 1;
    const testLimit = 10;

    test('should return list of notes when success', () async {
      // Arrange
      when(mockNoteService.fetchNotes(testPage, testLimit)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModels),
      );
      // Act
      final result = await dataSource.fetch(testPage, testLimit);
      // Assert
      expect(result, BaseResponse(data: tNoteModels));
    });
  });

  group('getById', () {
    const testId = 1;

    test('should return note data when success', () async {
      // Arrange
      when(mockNoteService.getNoteById(testId)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModel),
      );
      // Act
      final result = await dataSource.getById(testId);
      // Assert
      expect(result, BaseResponse(data: tNoteModel));
    });
  });

  group('update', () {
    const testId = 1;

    test('should return updated note data when success', () async {
      // Arrange
      when(mockNoteService.updateNote(testId, tNoteDto)).thenAnswer(
        (_) async => BaseResponse(data: tNoteModel),
      );
      // Act
      final result = await dataSource.update(testId, tNoteDto);
      // Assert
      expect(result, BaseResponse(data: tNoteModel));
    });
  });
}
