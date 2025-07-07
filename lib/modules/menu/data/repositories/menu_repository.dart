import 'package:flutter_boilerplate/modules/menu/data/data_sources/remote/menu_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_response_model.dart';

class MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  MenuRepository(this.remoteDataSource);

  Future<BaseResponse<CategoryModel>> getCategoryById(int id) {
    return remoteDataSource.getCategoryById(id);
  }

  Future<ResultState<List<CategoryModel>>> fetchCategories() async {
    try {
      final res12 = await remoteDataSource.getCategoryById(12);
      final res13 = await remoteDataSource.getCategoryById(13);
      return ResultState.success([
        res12.data!,
        res13.data!,
      ]);
    } catch (e) {
      return ResultState.failed('Failed to fetch categories');
    }
  }

  Future<MenuResponseModel> createMenu(MenuRequestModel body) async {
    try {
      return await remoteDataSource.createMenu(body);
    } catch (e) {
      rethrow;
    }
  }
}
