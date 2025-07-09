import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthRemoteDataSource dataSource;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    dataSource = AuthRemoteDataSource(mockAuthService);
  });

  group('login', () {
    // test('should return access token and refresh token when success', () async {
    //   // Arrange
    //   when(mockAuthService.login(tLoginDto)).thenAnswer(
    //     (_) async => BaseResponse(data: tTokenModel),
    //   );
    //   // Act
    //   final result = await dataSource.login(tLoginDto);
    //   // Assert
    //   expect(result, BaseResponse(data: tTokenModel));
    // });
  });

  group('validateAuth', () {
    test('should return auth data when success', () async {
      // Arrange
      when(mockAuthService.validateAuth()).thenAnswer(
        (_) async => BaseResponse(data: tAuthValidateModel),
      );
      // Act
      final result = await dataSource.validateAuth();
      // Assert
      expect(result, BaseResponse(data: tAuthValidateModel));
    });
  });

  group('logout', () {
    test('should return auth data when success', () async {
      // Arrange
      when(mockAuthService.logout(tLogoutDto)).thenAnswer(
        (_) async => BaseResponse(),
      );
      // Act
      await dataSource.logout(tLogoutDto);
      // Assert
      verify(mockAuthService.logout(tLogoutDto));
    });
  });
}
