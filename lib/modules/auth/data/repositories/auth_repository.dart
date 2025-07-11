import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/core/common/token_manager.dart';
import 'package:flutter_boilerplate/core/extensions/dio_exception_ext.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_request_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/refresh_token_dto.dart';
import 'package:flutter_boilerplate/shared/responses/base_error_response.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final UserRemoteDataSource _userRemoteDataSource;
  final TokenManager _tokenManager;

  const AuthRepository(
    this._remoteDataSource,
    this._localDataSource,
    this._userRemoteDataSource,
    this._tokenManager,
  );

  Future<Either<Failure, UserModel>> getActiveUser() async {
    try {
      final authSession = await _localDataSource.getAuthSession();
      if (authSession == null) {
        await _localDataSource.clearSession();
        return const Left(AuthFailure());
      }

      final user = await _userRemoteDataSource.getUserById(
        authSession.id ?? 0,
      );
      return Right(user.data!);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<TokenModel>>> login(
      LoginDto payload) async {
    try {
      final result = await _remoteDataSource.login(payload);
      if (result.data != null) {
        await _localDataSource.setToken(result.data!);
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, AuthValidateModel>> quickAuthCheck() async {
    try {
      final authSession = await _localDataSource.getAuthSession();
      if (authSession == null) {
        return const Left(AuthFailure());
      }

      final accessToken = await _localDataSource.getAccessToken();
      if (accessToken == null) {
        await _localDataSource.clearSession();
        return const Left(AuthFailure());
      }

      if (_tokenManager.isTokenExpired(accessToken)) {
        await _localDataSource.clearSession();
        return const Left(AuthFailure());
      }

      return Right(authSession);
    } catch (_) {
      await _localDataSource.clearSession();
      return const Left(AuthFailure());
    }
  }

  Future<Either<Failure, AuthValidateModel>> createAuthFromToken() async {
    try {
      final accessToken = await _localDataSource.getAccessToken();
      if (accessToken == null) {
        return const Left(AuthFailure());
      }

      final tokenData = _tokenManager.decodeToken(accessToken);

      if (tokenData == null) {
        return const Left(AuthFailure());
      }

      final authModel = AuthValidateModel(
        id: tokenData['id'] ?? 0,
        username: tokenData['username'] ?? '',
        hasGroups: [],
        hasPermissions: [],
        restaurantId: tokenData['restaurant_id'],
      );

      print('✅ authModel: $authModel');

      await _localDataSource.setAuthSession(authModel);
      return Right(authModel);
    } catch (e) {
      return const Left(AuthFailure());
    }
  }

  Future<Either<Failure, bool>> logout() async {
    try {
      await _localDataSource.deleteRefreshToken();
      await _localDataSource.clearSession();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Logout error: $e' as BaseErrorResponse?));
    }
  }

  Future<Either<Failure, BaseResponse<void>>> register(
      RegisterRequestModel payload) async {
    try {
      final response = await _remoteDataSource.register(payload);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<TokenModel>>> refreshToken(
      RefreshTokenDto payload) async {
    try {
      final result = await _remoteDataSource.refreshToken(payload);
      if (result.data != null) {
        await _localDataSource.setToken(result.data!);
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, AuthValidateModel>> getUserFromToken() async {
    try {
      final accessToken = await _localDataSource.getAccessToken();
      if (accessToken == null) {
        await _localDataSource.clearSession();
        return const Left(AuthFailure());
      }

      if (_tokenManager.isTokenExpired(accessToken)) {
        await _localDataSource.clearSession();
        return const Left(AuthFailure());
      }

      final result = await _remoteDataSource.getUserFromToken();
      final data = result.data;
      if (data == null) {
        await _localDataSource.clearSession();
        return const Left(AuthFailure());
      }

      await _localDataSource.setAuthSession(data);
      return Right(data);
    } catch (_) {
      await _localDataSource.clearSession();
      return const Left(AuthFailure());
    }
  }
}
