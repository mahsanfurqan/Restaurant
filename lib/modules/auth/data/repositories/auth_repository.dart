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
import 'package:flutter_boilerplate/modules/auth/data/models/register_response_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/refresh_token_dto.dart';
import 'package:flutter_boilerplate/shared/responses/base_error_response.dart';

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

  Future<Either<Failure, TokenModel>> login(LoginDto payload) async {
    try {
      final result = await _remoteDataSource.login(payload);
      await _localDataSource.setToken(result);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, AuthValidateModel>> validateAuth() async {
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

      final authData = await _remoteDataSource.validateAuth();
      if (authData.data == null) {
        await _localDataSource.clearSession();
        return const Left(AuthFailure());
      }

      await _localDataSource.setAuthSession(authData.data!);
      return Right(authData.data!);
    } catch (_) {
      await _localDataSource.clearSession();
      return const Left(AuthFailure());
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
      );
      await _localDataSource.setAuthSession(authModel);
      return Right(authModel);
    } catch (_) {
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

  Future<Either<Failure, RegisterDataModel>> register(
      RegisterRequestModel payload) async {
    try {
      final response = await _remoteDataSource.register(payload);

      if (response.data == null) {
        return Left(CacheFailure('Register response data is null'));
      }

      return Right(response.data!);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    } catch (e) {
      // Tangkap error parsing
      return Left(CacheFailure('Parsing error: ${e.toString()}'));
    }
  }

  Future<Either<Failure, TokenModel>> refreshToken(
      RefreshTokenDto payload) async {
    try {
      final result = await _remoteDataSource.refreshToken(payload);
      await _localDataSource.setToken(result);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }
}
