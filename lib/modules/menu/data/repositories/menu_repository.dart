import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/core/extensions/dio_exception_ext.dart';
import 'package:flutter_boilerplate/core/common/network_info.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/menu_local_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/remote/menu_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/storage_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

class MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;
  final MenuLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const MenuRepository(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, List<CategoryModel>>> fetchCategories(
      {bool forceRefresh = false}) async {
    try {
      // Jika forceRefresh atau cache kosong, ambil dari API
      if (forceRefresh) {
        await _localDataSource.clearAllCategories();
      }

      final cachedCategories = await _localDataSource.findAllCategories();
      if (cachedCategories.isNotEmpty && !forceRefresh) {
        return Right(cachedCategories);
      }

      final res = await _remoteDataSource.getCategories();
      final categories = res.data ?? [];

      if (categories.isNotEmpty) {
        await _localDataSource.insertAllCategories(categories);
      }

      return Right(categories);
    } on DioException catch (e) {
      final cachedCategories = await _localDataSource.findAllCategories();
      if (cachedCategories.isNotEmpty) {
        return Right(cachedCategories);
      }
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<MenuModel>>> createMenu(
      MenuRequestModel body) async {
    try {
      final res = await _remoteDataSource.createMenu(body);
      await _localDataSource.clearAll();
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, List<MenuModel>>> fetchMenus({
    bool refresh = false,
    bool loadMore = false,
    int? page = 1,
    int limit = 10,
    bool forceOnline = false,
  }) async {
    final hasInternet = await _networkInfo.isConnected;
    final localResult = await _localDataSource.findAll();
    if (!forceOnline && !hasInternet) {
      // Offline mode, return local data
      if (localResult.isNotEmpty) {
        return Right(localResult);
      } else {
        return Left(ServerFailure(null));
      }
    }
    if (localResult.isNotEmpty && !refresh && !loadMore) {
      return Right(localResult);
    } else {
      try {
        final remoteResult = await _remoteDataSource.getMenus();
        final menus = remoteResult.data ?? [];

        if (refresh) {
          await _localDataSource.clearAll();
          if (menus.isNotEmpty) {
            await _localDataSource.insertAll(menus);
          }
        }
        return Right(menus);
      } on DioException catch (e) {
        if (localResult.isNotEmpty) {
          return Right(localResult);
        }
        return Left(ServerFailure(e.errorResponse));
      }
    }
  }

  Future<Either<Failure, BaseResponse<StorageUploadResponseModel>>> uploadFile({
    required String filePath,
    required String folder,
  }) async {
    try {
      final response = await _remoteDataSource.uploadFileWithDio(
        filePath: filePath,
        folder: folder,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, String>> deleteMenu(int id) async {
    try {
      await _remoteDataSource.deleteMenu(id);
      await _localDataSource.clearAll();
      return const Right('Menu deleted');
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<RestaurantModel>>> getRestaurant(
      int id) async {
    try {
      final response = await _remoteDataSource.getRestaurant(id);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<RestaurantModel>>> updateRestaurant(
    int id,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _remoteDataSource.updateRestaurant(id, body);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, List<MenuModel>>> refreshMenus(
      {bool forceOnline = false}) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!forceOnline && !hasInternet) {
      final localResult = await _localDataSource.findAll();
      if (localResult.isNotEmpty) {
        return Right(localResult);
      } else {
        return Left(ServerFailure(null));
      }
    }
    try {
      final response = await _remoteDataSource.getMenus();
      final menus = response.data ?? [];

      await _localDataSource.clearAll();
      if (menus.isNotEmpty) {
        await _localDataSource.insertAll(menus);
      }

      return Right(menus);
    } on DioException catch (e) {
      final localResult = await _localDataSource.findAll();
      if (localResult.isNotEmpty) {
        return Right(localResult);
      }
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<MenuModel>>> updateMenu(
    int id,
    MenuRequestModel request,
  ) async {
    print('update menu');
    try {
      final res = await _remoteDataSource.updateMenu(id, request);
      print('berhasil');
      await _localDataSource.clearAll();

      return Right(res);
    } on DioException catch (e) {
      print('gagal');
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<bool> hasCachedData() async {
    final menus = await _localDataSource.findAll();
    return menus.isNotEmpty;
  }

  Future<void> clearCache() async {
    await _localDataSource.clearAll();
  }
}
