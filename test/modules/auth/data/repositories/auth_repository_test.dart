import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthRepository repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockUserRemoteDataSource mockUserRemoteDataSource;
  late MockTokenManager mockTokenManager;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockUserRemoteDataSource = MockUserRemoteDataSource();
    mockTokenManager = MockTokenManager();
    repository = AuthRepository(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockUserRemoteDataSource,
      mockTokenManager,
    );
  });

  final tAccessToken = tTokenModel.accessToken;

  group('getActiveUser', () {
    const testId = 1;

    test('should return user data when get user from remote success', () async {
      // Arrange
      when(mockLocalDataSource.getAuthSession())
          .thenAnswer((_) async => tAuthValidateModel);
      when(mockUserRemoteDataSource.getUserById(testId))
          .thenAnswer((_) async => BaseResponse(data: tUserModel));
      // Act
      final result = await repository.getActiveUser();
      // Assert
      verify(mockLocalDataSource.getAuthSession());
      verify(mockUserRemoteDataSource.getUserById(testId));

      expect(result, Right(tUserModel));
    });

    test('should return ServerFailure when get user from remote failed',
        () async {
      // Arrange
      when(mockLocalDataSource.getAuthSession())
          .thenAnswer((_) async => tAuthValidateModel);
      when(mockUserRemoteDataSource.getUserById(testId)).thenThrow(DioException(
        requestOptions: RequestOptions(),
        error: tBaseErrorResponse,
      ));
      // Act
      final result = await repository.getActiveUser();
      // Assert
      verify(mockLocalDataSource.getAuthSession());
      verify(mockUserRemoteDataSource.getUserById(testId));
      verifyNever(mockLocalDataSource.clearSession());

      expect(result, Left(ServerFailure(tBaseErrorResponse)));
    });

    test('should return AuthFailure when get auth session failed', () async {
      // Arrange
      when(mockLocalDataSource.getAuthSession()).thenAnswer(
        (_) async => null,
      );
      when(mockLocalDataSource.clearSession()).thenAnswer((_) async => true);
      // Act
      final result = await repository.getActiveUser();
      // Assert
      verify(mockLocalDataSource.getAuthSession());
      verify(mockLocalDataSource.clearSession());
      verifyNever(mockUserRemoteDataSource.getUserById(testId));

      expect(result, Left(AuthFailure()));
    });
  });

  group('validateAuth', () {
    test(
        'should return current auth data when the call to data source is successful',
        () async {
      // Arrange
      when(mockLocalDataSource.getAccessToken())
          .thenAnswer((_) async => tAccessToken);
      when(mockTokenManager.isTokenExpired(tAccessToken))
          .thenAnswer((_) => false);
      when(mockRemoteDataSource.validateAuth())
          .thenAnswer((_) async => BaseResponse(data: tAuthValidateModel));
      when(mockLocalDataSource.setAuthSession(tAuthValidateModel))
          .thenAnswer((_) async => true);
      // Act
      final result = await repository.validateAuth();
      // Assert
      verify(mockLocalDataSource.getAccessToken());
      verify(mockTokenManager.isTokenExpired(tAccessToken));
      verify(mockRemoteDataSource.validateAuth());
      verify(mockLocalDataSource.setAuthSession(tAuthValidateModel));

      expect(result, const Right(tAuthValidateModel));
    });

    test(
        'should return auth failure and clear session when access token not saved in local',
        () async {
      // Arrange
      when(mockLocalDataSource.getAccessToken()).thenAnswer((_) async => null);
      when(mockLocalDataSource.clearSession()).thenAnswer((_) async => true);
      // Act
      final result = await repository.validateAuth();
      // Assert
      verify(mockLocalDataSource.getAccessToken());
      verify(mockLocalDataSource.clearSession());
      verifyNever(mockTokenManager.isTokenExpired(tAccessToken));
      verifyNever(mockRemoteDataSource.validateAuth());
      verifyNever(mockLocalDataSource.setAuthSession(tAuthValidateModel));

      expect(result, const Left(AuthFailure()));
    });

    test('should return auth failure and clear session when token is expired',
        () async {
      // Arrange
      when(mockLocalDataSource.getAccessToken())
          .thenAnswer((_) async => tAccessToken);
      when(mockTokenManager.isTokenExpired(tAccessToken))
          .thenAnswer((_) => true);
      when(mockLocalDataSource.clearSession()).thenAnswer((_) async => true);
      // Act
      final result = await repository.validateAuth();
      // Assert
      verify(mockLocalDataSource.getAccessToken());
      verify(mockTokenManager.isTokenExpired(tAccessToken));
      verify(mockLocalDataSource.clearSession());

      expect(result, const Left(AuthFailure()));
    });

    test(
        'should return auth failure and clear session when get auth data from remote is failed',
        () async {
      // Arrange
      when(mockLocalDataSource.getAccessToken())
          .thenAnswer((_) async => tAccessToken);
      when(mockTokenManager.isTokenExpired(tAccessToken))
          .thenAnswer((_) => false);
      when(mockRemoteDataSource.validateAuth())
          .thenAnswer((_) async => BaseResponse());
      when(mockLocalDataSource.clearSession()).thenAnswer((_) async => true);
      // Act
      final result = await repository.validateAuth();
      // Assert
      verify(mockLocalDataSource.getAccessToken());
      verify(mockTokenManager.isTokenExpired(tAccessToken));
      verify(mockRemoteDataSource.validateAuth());
      verify(mockLocalDataSource.clearSession());
      verifyNever(mockLocalDataSource.setAuthSession(tAuthValidateModel));

      expect(result, const Left(AuthFailure()));
    });
  });

  group('login', () {
    test('should return tokens and save token to local when login is success',
        () async {
      // Arrange
      when(mockRemoteDataSource.login(tLoginDto))
          .thenAnswer((_) async => const BaseResponse(data: tTokenModel));
      when(mockLocalDataSource.setToken(tTokenModel))
          .thenAnswer((_) async => true);
      // Act
      final result = await repository.login(tLoginDto);
      // Assert
      expect(result, const Right(tTokenModel));
    });

    test('should return server failure when login is failed', () async {
      // Arrange
      when(mockRemoteDataSource.login(tLoginDto)).thenThrow(DioException(
        requestOptions: RequestOptions(),
        error: tBaseErrorResponse,
      ));
      // Act
      final result = await repository.login(tLoginDto);
      // Assert
      expect(result, const Left(ServerFailure(tBaseErrorResponse)));
    });
  });

  group('logout', () {
    test('should return true and clear session when refresh token is null',
        () async {
      // Arrange
      when(mockLocalDataSource.getRefreshToken()).thenAnswer((_) async => null);
      when(mockLocalDataSource.clearSession()).thenAnswer((_) async => true);
      // Act
      final result = await repository.logout();
      // Assert
      expect(result, Right(true));
    });

    test('should return true and clear session when logout is success',
        () async {
      // Arrange
      when(mockLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => tTokenModel.refreshToken);
      when(mockRemoteDataSource.logout(tLogoutDto))
          .thenAnswer((_) async => BaseResponse());
      when(mockLocalDataSource.deleteRefreshToken())
          .thenAnswer((_) async => true);
      when(mockLocalDataSource.clearSession()).thenAnswer((_) async => true);
      // Act
      final result = await repository.logout();
      // Assert
      expect(result, Right(true));
    });

    test('should return false when logout is failed', () async {
      // Arrange
      when(mockLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => tTokenModel.refreshToken);
      when(mockRemoteDataSource.logout(tLogoutDto)).thenThrow(DioException(
        requestOptions: RequestOptions(),
        error: tBaseErrorResponse,
      ));
      // Act
      final result = await repository.logout();
      // Assert
      expect(result, const Left(ServerFailure(tBaseErrorResponse)));
    });
  });
}
