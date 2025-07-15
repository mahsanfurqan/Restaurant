import 'dart:convert';

import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  const AuthLocalDataSource(this._secureStorage);

  Future<bool> setAuthSession(AuthValidateModel auth) async {
    try {
      final key = AppConstants.secureStorageKeys.authSession;
      await _secureStorage.write(
        key: key,
        value: jsonEncode(auth.toJson()),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<AuthValidateModel?> getAuthSession() async {
    final key = AppConstants.secureStorageKeys.authSession;
    final authSession = await _secureStorage.read(key: key);

    if (authSession == null) return null;
    return AuthValidateModel.fromJson(jsonDecode(authSession));
  }

  Future<bool> setToken(TokenModel tokenResponse) async {
    try {
      final refreshTokenKey = AppConstants.secureStorageKeys.refreshToken;
      final accessTokenKey = AppConstants.secureStorageKeys.accessToken;

      await _secureStorage.write(
          key: refreshTokenKey, value: tokenResponse.refreshToken);
      await _secureStorage.write(
          key: accessTokenKey, value: tokenResponse.accessToken);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    final key = AppConstants.secureStorageKeys.accessToken;
    return await _secureStorage.read(key: key);
  }

  Future<String?> getRefreshToken() async {
    final key = AppConstants.secureStorageKeys.refreshToken;
    return await _secureStorage.read(key: key);
  }

  Future<bool> deleteRefreshToken() async {
    try {
      final refreshTokenKey = AppConstants.secureStorageKeys.refreshToken;
      await _secureStorage.delete(key: refreshTokenKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearSession() async {
    try {
      final keys = [
        AppConstants.secureStorageKeys.accessToken,
        AppConstants.secureStorageKeys.authSession,
      ];

      await Future.wait(keys.map((key) => _secureStorage.delete(key: key)));

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<TokenModel?> getTokenModelFromStorage() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final authSession = await getAuthSession();
    if (accessToken != null &&
        refreshToken != null &&
        authSession != null &&
        authSession.username != null) {
      return TokenModel(
          email: authSession.username!,
          accessToken: accessToken,
          refreshToken: refreshToken);
    }
    return null;
  }
}
