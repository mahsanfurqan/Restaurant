import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/remote/menu_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_response_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_error_response.dart';

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

  Future<Either<Failure, MenuResponseModel>> createMenu(
      MenuRequestModel body) async {
    try {
      final res = await remoteDataSource.createMenu(body);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }

  Future<Either<Failure, List<MenuModel>>> fetchMenus() async {
    try {
      final response = await remoteDataSource.getMenus();
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ServerFailure(e.errorResponse));
    }
  }
}
