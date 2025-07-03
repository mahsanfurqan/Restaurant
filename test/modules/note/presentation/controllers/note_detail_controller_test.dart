import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_detail_controller.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late NoteDetailController controller;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    mockNoteRepository = MockNoteRepository();
    controller = NoteDetailController(mockNoteRepository);
  });

  const testId = 1;

  group('getNoteById', () {
    test('state should initial', () async {
      // Assert
      expect(controller.noteState.value, isA<ResultInitial>());
    });

    test('state should loading when calling getNoteById', () async {
      // Arrange
      when(mockNoteRepository.getNoteById(testId)).thenAnswer(
        (_) async => Right(BaseResponse(data: tNoteModel)),
      );
      // Act
      controller.id = testId;
      controller.getNoteById();
      // Assert
      final state = controller.noteState.value;
      expect(state, isA<ResultLoading>());
    });

    test('state should success when get note by id is success', () async {
      // Arrange
      when(mockNoteRepository.getNoteById(testId)).thenAnswer(
        (_) async => Right(BaseResponse(data: tNoteModel)),
      );
      // Act
      controller.id = testId;
      await controller.getNoteById();
      // Assert
      final state = controller.noteState.value;
      expect(state, isA<ResultSuccess<NoteModel>>());
      expect((state as ResultSuccess<NoteModel>).data, tNoteModel);
    });

    test('state should failed when get note by id is failed', () async {
      // Arrange
      when(mockNoteRepository.getNoteById(testId)).thenAnswer(
        (_) async => Left(ServerFailure(tBaseErrorResponse)),
      );
      // Act
      controller.id = testId;
      await controller.getNoteById();
      // Assert
      final state = controller.noteState.value;
      expect(state, isA<ResultFailed>());
    });
  });

  group('deleteNote', () {
    test('state should initial', () async {
      // Assert
      expect(controller.deleteNoteState.value, isA<ResultInitial>());
    });

    test('state should loading when calling deleteNote', () async {
      // Arrange
      when(mockNoteRepository.deleteNote(tNoteModel.id!)).thenAnswer(
        (_) async => Right('Note deleted'),
      );
      // Act
      controller.id = testId;
      controller.deleteNote();
      // Assert
      final state = controller.deleteNoteState.value;
      expect(state, isA<ResultLoading>());
    });

    test('state should success when delete note is success', () async {
      // Arrange
      when(mockNoteRepository.deleteNote(tNoteModel.id!)).thenAnswer(
        (_) async => Right('Note deleted'),
      );
      // Act
      controller.id = testId;
      await controller.deleteNote();
      // Assert
      final state = controller.deleteNoteState.value;
      expect(state, isA<ResultSuccess<String>>());
      expect((state as ResultSuccess<String>).data, 'Note deleted');
    });

    test('state should failed when delete note is failed', () async {
      // Arrange
      when(mockNoteRepository.deleteNote(tNoteModel.id!)).thenAnswer(
        (_) async => Left(ServerFailure(tBaseErrorResponse)),
      );
      // Act
      controller.id = testId;
      await controller.deleteNote();
      // Assert
      final state = controller.deleteNoteState.value;
      expect(state, isA<ResultFailed>());
    });
  });
}
