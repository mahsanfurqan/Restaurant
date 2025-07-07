import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/login_controller.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    mockAuthRepository = MockAuthRepository();
    controller = LoginController(mockAuthRepository);
  });

  tearDown(() {
    controller.dispose();
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';

    test('state should initial', () async {
      // Assert
      final state = controller.loginState.value;
      expect(state, isA<ResultInitial>());
    });

    // TODO: Fix test after AuthController mock is available
    // test('state should loading when login is called', () async {
    //   // Arrange
    //   when(mockAuthRepository.login(tLoginDto)).thenAnswer(
    //     (_) async => const Right(tTokenModel),
    //   );
    //   // Act
    //   controller.emailCtrl.text = tEmail;
    //   controller.passCtrl.text = tPassword;

    //   controller.login();
    //   // Assert
    //   final state = controller.loginState.value;
    //   expect(state, isA<ResultLoading>());
    // });

    // test('state should success if login is successful', () async {
    //   // Arrange
    //   when(mockAuthRepository.login(tLoginDto))
    //       .thenAnswer((_) async => const Right(tTokenModel));
    //   // Act
    //   controller.emailCtrl.text = tEmail;
    //   controller.passCtrl.text = tPassword;

    //   await controller.login();
    //   // Assert
    //   final state = controller.loginState.value;
    //   expect(state, isA<ResultSuccess<TokenModel>>());
    //   expect((state as ResultSuccess<TokenModel>).data, tTokenModel);
    // });

    // test('state should failed if login is unsuccessful', () async {
    //   // Arrange
    //   when(mockAuthRepository.login(tLoginDto)).thenAnswer(
    //     (_) async => const Left(ServerFailure(tBaseErrorResponse)),
    //   );
    //   // Act
    //   controller.emailCtrl.text = tEmail;
    //   controller.passCtrl.text = tPassword;

    //   await controller.login();
    //   // Assert
    //   final state = controller.loginState.value;
    //   expect(state, isA<ResultFailed>());
    // });
  });
}
