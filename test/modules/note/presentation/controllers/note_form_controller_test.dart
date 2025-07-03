import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_form_controller.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late NoteFormController controller;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    mockNoteRepository = MockNoteRepository();
    controller = NoteFormController(mockNoteRepository);
  });

  group('saveNote', () {
    test('state should initial', () async {
      // Assert
      expect(controller.saveNoteState.value, isA<ResultInitial>());
    });

    test('state should loading when saveNote called and note null', () async {
      // Arrange
      when(mockNoteRepository.createNote(tNoteDto)).thenAnswer(
        (_) async => Right(BaseResponse(data: tNoteModel)),
      );
      // Act
      controller.note = null;
      controller.titleCtrl.text = 'title';
      controller.contentCtrl.text = 'content';

      controller.saveNote();
      // Assert
      final state = controller.saveNoteState.value;
      expect(state, isA<ResultLoading>());
    });

    test('state should loading when saveNote called and note not null',
        () async {
      // Arrange
      when(mockNoteRepository.updateNote(tNoteModel.id, tNoteDto)).thenAnswer(
        (_) async => Right(BaseResponse(data: tNoteModel)),
      );
      // Act
      controller.note = tNoteModel;
      controller.titleCtrl.text = 'title';
      controller.contentCtrl.text = 'content';

      controller.saveNote();
      // Assert
      final state = controller.saveNoteState.value;
      expect(state, isA<ResultLoading>());
    });

    test('state should success and createNote when success', () async {
      // Arrange
      when(mockNoteRepository.createNote(tNoteDto)).thenAnswer(
        (_) async => Right(BaseResponse(data: tNoteModel)),
      );
      // Act
      controller.note = null;
      controller.titleCtrl.text = 'title';
      controller.contentCtrl.text = 'content';

      await controller.saveNote();
      // Assert
      verify(mockNoteRepository.createNote(tNoteDto));
      verifyNever(mockNoteRepository.updateNote(tNoteModel.id, tNoteDto));

      final state = controller.saveNoteState.value;
      expect(state, isA<ResultSuccess<bool>>());
      expect((state as ResultSuccess<bool>).data, true);
    });

    test('state should success and updateNote when success', () async {
      // Arrange
      when(mockNoteRepository.updateNote(tNoteModel.id, tNoteDto)).thenAnswer(
        (_) async => Right(BaseResponse(data: tNoteModel)),
      );
      // Act
      controller.note = tNoteModel;
      controller.titleCtrl.text = 'title';
      controller.contentCtrl.text = 'content';

      await controller.saveNote();
      // Assert
      verify(mockNoteRepository.updateNote(tNoteModel.id, tNoteDto));
      verifyNever(mockNoteRepository.createNote(tNoteDto));

      final state = controller.saveNoteState.value;
      expect(state, isA<ResultSuccess<bool>>());
      expect((state as ResultSuccess<bool>).data, true);
    });

    test('state should failed when failed createNote', () async {
      // Arrange
      when(mockNoteRepository.createNote(tNoteDto)).thenAnswer(
        (_) async => Left(ServerFailure(tBaseErrorResponse)),
      );
      // Act
      controller.note = null;
      controller.titleCtrl.text = 'title';
      controller.contentCtrl.text = 'content';

      await controller.saveNote();
      // Assert
      verify(mockNoteRepository.createNote(tNoteDto));
      verifyNever(mockNoteRepository.updateNote(tNoteModel.id, tNoteDto));

      final state = controller.saveNoteState.value;
      expect(state, isA<ResultFailed>());
    });

    test('state should failed when failed updateNote', () async {
      // Arrange
      when(mockNoteRepository.updateNote(tNoteModel.id, tNoteDto)).thenAnswer(
        (_) async => Left(ServerFailure(tBaseErrorResponse)),
      );
      // Act
      controller.note = tNoteModel;
      controller.titleCtrl.text = 'title';
      controller.contentCtrl.text = 'content';

      await controller.saveNote();
      // Assert
      verify(mockNoteRepository.updateNote(tNoteModel.id, tNoteDto));
      verifyNever(mockNoteRepository.createNote(tNoteDto));

      final state = controller.saveNoteState.value;
      expect(state, isA<ResultFailed>());
    });
  });
}
