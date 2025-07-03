import 'dart:convert';

import 'package:flutter_boilerplate/modules/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthLocalDataSource dataSource;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    dataSource = AuthLocalDataSource(
      mockFlutterSecureStorage,
    );
  });

  final tRefreshTokenKey = AppConstants.secureStorageKeys.refreshToken;
  final tAccessTokenKey = AppConstants.secureStorageKeys.accessToken;
  final tAuthSessionKey = AppConstants.secureStorageKeys.authSession;

  final tRefreshToken = tTokenModel.refreshToken;
  final tAccessToken = tTokenModel.accessToken;

  group('setAuthSession', () {
    test('should return true when save auth session is success', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
        key: tAuthSessionKey,
        value: jsonEncode(tAuthValidateJson),
      )).thenAnswer((_) async => true);
      // Act
      final result = await dataSource.setAuthSession(tAuthValidateModel);
      // Assert
      expect(result, true);
    });

    test('should return false when save auth session is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
        key: tAuthSessionKey,
        value: jsonEncode(tAuthValidateJson),
      )).thenThrow(Exception());
      // Act
      final result = await dataSource.setAuthSession(tAuthValidateModel);
      // Assert
      expect(result, false);
    });
  });

  group('getAuthSession', () {
    test('should return auth session from local when success', () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: tAuthSessionKey)).thenAnswer(
        (_) async => jsonEncode(tAuthValidateJson),
      );
      // Act
      final result = await dataSource.getAuthSession();
      // Assert
      expect(result, tAuthValidateModel);
    });

    test('should return null from local when failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: tAuthSessionKey)).thenAnswer(
        (_) async => null,
      );
      // Act
      final result = await dataSource.getAuthSession();
      // Assert
      expect(result, null);
    });
  });

  group('setToken', () {
    test('should return true when set token is success', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
              key: tRefreshTokenKey, value: tRefreshToken))
          .thenAnswer((_) async => true);
      when(mockFlutterSecureStorage.write(
              key: tAccessTokenKey, value: tAccessToken))
          .thenAnswer((_) async => true);
      // Act
      final result = await dataSource.setToken(tTokenModel);
      // Assert
      expect(result, true);
    });

    test('should return false when set refresh token is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
        key: tRefreshTokenKey,
        value: tRefreshToken,
      )).thenThrow(Exception());
      when(mockFlutterSecureStorage.write(
        key: tAccessTokenKey,
        value: tAccessToken,
      )).thenAnswer((_) async => true);
      // Act
      final result = await dataSource.setToken(tTokenModel);
      // Assert
      expect(result, false);
    });

    test('should return false when set access token is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
        key: tRefreshTokenKey,
        value: tRefreshToken,
      )).thenAnswer((_) async => true);
      when(mockFlutterSecureStorage.write(
        key: tAccessTokenKey,
        value: tAccessToken,
      )).thenThrow(Exception());
      // Act
      final result = await dataSource.setToken(tTokenModel);
      // Assert
      expect(result, false);
    });

    test('should return false when set token is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.write(
        key: tRefreshTokenKey,
        value: tRefreshToken,
      )).thenThrow(Exception());
      when(mockFlutterSecureStorage.write(
        key: tAccessTokenKey,
        value: tAccessToken,
      )).thenAnswer((_) async => true);
      // Act
      final result = await dataSource.setToken(tTokenModel);
      // Assert
      expect(result, false);
    });
  });

  group('getAccessToken', () {
    test('should return access token when get access token is success',
        () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: tAccessTokenKey))
          .thenAnswer((_) async => tAccessToken);
      // Act
      final result = await dataSource.getAccessToken();
      // Assert
      expect(result, tAccessToken);
    });

    test('should return null when get access token is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: tAccessTokenKey))
          .thenAnswer((_) async => null);
      // Act
      final result = await dataSource.getAccessToken();
      // Assert
      expect(result, null);
    });
  });

  group('getRefreshToken', () {
    test('should return access token when get refresh token is success',
        () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: tRefreshTokenKey))
          .thenAnswer((_) async => tRefreshToken);
      // Act
      final result = await dataSource.getRefreshToken();
      // Assert
      expect(result, tRefreshToken);
    });

    test('should return null when get refresh token is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.read(key: tRefreshTokenKey))
          .thenAnswer((_) async => null);
      // Act
      final result = await dataSource.getRefreshToken();
      // Assert
      expect(result, null);
    });
  });

  group('deleteRefreshToken', () {
    final refreshTokenKey = AppConstants.secureStorageKeys.refreshToken;

    test('should return true when delete refresh token session is success',
        () async {
      // Arrange
      when(mockFlutterSecureStorage.delete(key: refreshTokenKey))
          .thenAnswer((_) async => true);
      // Act
      final result = await dataSource.deleteRefreshToken();
      // Assert
      expect(result, true);
    });

    test('should return false when delete refresh token session is failed',
        () async {
      // Arrange
      when(mockFlutterSecureStorage.delete(key: refreshTokenKey))
          .thenThrow(Exception());
      // Act
      final result = await dataSource.deleteRefreshToken();
      // Assert
      expect(result, false);
    });
  });

  group('clearSession', () {
    final accessTokenKey = AppConstants.secureStorageKeys.accessToken;
    final authSession = AppConstants.secureStorageKeys.authSession;

    test('should return true when clear session is success', () async {
      // Arrange
      when(mockFlutterSecureStorage.delete(key: accessTokenKey))
          .thenAnswer((_) async => true);
      when(mockFlutterSecureStorage.delete(key: authSession))
          .thenAnswer((_) async => true);
      // Act
      final result = await dataSource.clearSession();
      // Assert
      expect(result, true);
    });

    test('should return false when delete access token session is failed',
        () async {
      // Arrange
      when(mockFlutterSecureStorage.delete(key: accessTokenKey))
          .thenThrow(Exception());
      when(mockFlutterSecureStorage.delete(key: authSession))
          .thenAnswer((_) async => true);
      // Act
      final result = await dataSource.clearSession();
      // Assert
      expect(result, false);
    });

    test('should return false when delete auth session is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.delete(key: accessTokenKey))
          .thenAnswer((_) async => true);
      when(mockFlutterSecureStorage.delete(key: authSession))
          .thenThrow(Exception());
      // Act
      final result = await dataSource.clearSession();
      // Assert
      expect(result, false);
    });

    test('should return false when clear session is failed', () async {
      // Arrange
      when(mockFlutterSecureStorage.delete(key: accessTokenKey))
          .thenThrow(Exception());
      when(mockFlutterSecureStorage.delete(key: authSession))
          .thenThrow(Exception());
      // Act
      final result = await dataSource.clearSession();
      // Assert
      expect(result, false);
    });
  });
}
