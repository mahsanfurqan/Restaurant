import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/remote/menu_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_error_response.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/storage_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';

extension on DioException {
  BaseErrorResponse? get errorResponse => response?.data is Map<String, dynamic>
      ? BaseErrorResponse.fromJson(response?.data)
      : null;
}

class MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  MenuRepository(this.remoteDataSource);

  Future<Either<Failure, List<CategoryModel>>> fetchCategories() async {
    try {
      final res = await remoteDataSource.getCategories();
      return Right(res.data ?? []);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<MenuModel>>> createMenu(
      MenuRequestModel body) async {
    try {
      final res = await remoteDataSource.createMenu(body);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<List<MenuModel>>>> fetchMenus() async {
    try {
      final response = await remoteDataSource.getMenus();
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, StorageUploadResponseModel>> uploadFile({
    required String filePath,
    required String folder,
  }) async {
    try {
      final response = await remoteDataSource.uploadFileWithDio(
          filePath: filePath, folder: folder);
      return Right(response.data!);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, void>> deleteMenu(int id) async {
    try {
      await remoteDataSource.deleteMenu(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<RestaurantModel>>> getRestaurant(
      int id) async {
    try {
      final res = await remoteDataSource.getRestaurant(id);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, BaseResponse<RestaurantModel>>> updateRestaurant(
      int id, Map<String, dynamic> body) async {
    try {
      final res = await remoteDataSource.updateRestaurant(id, body);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }
}
