import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/common/token_manager.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final TokenManager _tokenManager;

  const TokenInterceptor(
    this._dio,
    this._secureStorage,
    this._tokenManager,
  );

  Future<String?> _getRefreshToken() async {
    final key = AppConstants.secureStorageKeys.refreshToken;
    return await _secureStorage.read(key: key);
  }

  Future<void> _storeNewTokens(TokenModel newTokens) async {
    await Future.wait([
      _secureStorage.write(
        key: AppConstants.secureStorageKeys.refreshToken,
        value: newTokens.refreshToken,
      ),
      _secureStorage.write(
        key: AppConstants.secureStorageKeys.accessToken,
        value: newTokens.accessToken,
      ),
    ]);
  }

  Future<void> _clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) {
      await _clearSecureStorage();
      return false;
    }

    if (_tokenManager.isTokenExpired(refreshToken)) {
      await _clearSecureStorage();
      return false;
    }

    try {
      final payload = {'refreshToken': refreshToken};
      final response = await _dio.post('/auth/refresh-token', data: payload);

      final newTokens = TokenModel.fromJson(response.data['data']);
      await _storeNewTokens(newTokens);

      return true;
    } catch (e) {
      await _clearSecureStorage();
      return false;
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding Authorization header for auth endpoints
    final isAuthEndpoint = options.uri.path.contains('/auth/login') ||
        options.uri.path.contains('/auth/register') ||
        options.uri.path.contains('/auth/refresh-token');

    if (!isAuthEndpoint) {
      final accessToken = await _secureStorage.read(
        key: AppConstants.secureStorageKeys.accessToken,
      );
      if (accessToken?.isNotEmpty == true) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.requestOptions.uri.path.contains('login')) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final retryResponse = await _dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        return handler.resolve(retryResponse);
      } else {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
