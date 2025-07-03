import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/home/presentation/controllers/home_controller.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late HomeController controller;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    mockNoteRepository = MockNoteRepository();
    controller = HomeController(mockNoteRepository);
  });

  const testPage = 1;
  const testLimit = 10;

  group('fetchNotes', () {
    test('state should be loading when fetching notes', () async {
      // Arrange
      when(mockNoteRepository.fetchNotes(
        refresh: true,
        loadMore: false,
        page: testPage,
        limit: testLimit,
      )).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(tNoteModels);
        },
      );
      // Act
      controller.fetchNotes(refresh: true);
      // Assert
      expect(controller.notesState.value, isA<ResultLoading>());
    });

    test('state should initial when get users is successfully but no data',
        () async {
      // Arrange
      when(mockNoteRepository.fetchNotes(
        refresh: true,
        loadMore: false,
        page: testPage,
        limit: testLimit,
      )).thenAnswer(
        (_) async => const Right([]),
      );
      // Act
      await controller.fetchNotes(refresh: true);
      // Assert
      final state = controller.notesState.value;
      expect(state, isA<ResultInitial>());
    });

    test('state should success when get users is successfully', () async {
      // Arrange
      when(mockNoteRepository.fetchNotes(
        refresh: true,
        loadMore: false,
        page: testPage,
        limit: testLimit,
      )).thenAnswer(
        (_) async => Right(tNoteModels),
      );
      // Act
      await controller.fetchNotes(refresh: true);
      // Assert
      final state = controller.notesState.value;
      expect(state, isA<ResultSuccess<List<NoteModel>>>());
    });

    test('state should failed when get users is unsuccessfully', () async {
      // Arrange
      when(mockNoteRepository.fetchNotes(
        refresh: true,
        loadMore: false,
        page: testPage,
        limit: testLimit,
      )).thenAnswer(
        (_) async => const Left(
          ServerFailure(tBaseErrorResponse),
        ),
      );
      // Act
      await controller.fetchNotes(refresh: true);
      // Assert
      final state = controller.notesState.value;
      expect(state, isA<ResultFailed>());
    });
  });
}
