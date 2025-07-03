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
import 'package:flutter_boilerplate/modules/auth/data/models/logout_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';

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
      await _localDataSource.setToken(result.data!);

      return Right(result.data!);
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

  Future<Either<Failure, bool>> logout() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        await _localDataSource.clearSession();
        return const Right(true);
      }

      final payload = LogoutDto(refreshToken: refreshToken);
      await _remoteDataSource.logout(payload);

      await Future.wait([
        _localDataSource.deleteRefreshToken(),
        _localDataSource.clearSession(),
      ]);

      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }
}
