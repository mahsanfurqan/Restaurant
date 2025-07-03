import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/setting/presentation/controllers/setting_controller.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SettingController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    mockAuthRepository = MockAuthRepository();
    controller = SettingController(
      mockAuthRepository,
    );
  });

  group('getActiveUser', () {
    test('state should initial', () async {
      // Assert
      expect(controller.userState.value, isA<ResultInitial>());
    });

    test('state should loading when function called', () async {
      // Arrange
      when(mockAuthRepository.getActiveUser()).thenAnswer(
        (_) async => Right(tUserModel),
      );
      // Act
      controller.getActiveUser();
      // Assert
      final state = controller.userState.value;
      expect(state, isA<ResultLoading>());
    });

    test('state should success when get data from repository successfully',
        () async {
      // Arrange
      when(mockAuthRepository.getActiveUser()).thenAnswer(
        (_) async => Right(tUserModel),
      );
      // Act
      await controller.getActiveUser();
      // Assert
      final state = controller.userState.value;
      expect(state, isA<ResultSuccess>());
      expect((state as ResultSuccess).data, tUserModel);
    });

    test('state should failed when get data from repository unsuccessfully',
        () async {
      // Arrange
      when(mockAuthRepository.getActiveUser()).thenAnswer(
        (_) async => Left(ServerFailure(tBaseErrorResponse)),
      );
      // Act
      await controller.getActiveUser();
      // Assert
      final state = controller.userState.value;
      expect(state, isA<ResultFailed>());
    });
  });

  group('logout', () {
    test('state should initial', () async {
      // Assert
      final state = controller.logoutState.value;
      expect(state, isA<ResultInitial>());
    });

    test('state should loading when logout called', () async {
      // Arrange
      when(mockAuthRepository.logout()).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(true);
        },
      );
      // Act
      controller.logout();
      // Assert
      expect(controller.logoutState.value, isA<ResultLoading>());
    });

    test('state should be loading when logging out', () async {
      // Arrange
      when(mockAuthRepository.logout()).thenAnswer(
        (_) async => Right(true),
      );
      // Act
      final logoutFuture = controller.logout();
      // Assert
      expect(controller.logoutState.value, isA<ResultLoading>());
      await logoutFuture;
    });
    test('state should success when logout is successful', () async {
      // Arrange
      when(mockAuthRepository.logout()).thenAnswer((_) async => Right(true));
      // Act
      await controller.logout();
      // Assert
      final state = controller.logoutState.value;
      expect(state, isA<ResultSuccess<bool>>());
    });
  });
}
