import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/storage_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

import 'services/menu_service.dart';

class MenuRemoteDataSource {
  final Dio dioClient;
  final MenuService _service;
  const MenuRemoteDataSource(this._service, this.dioClient);

  Future<BaseResponse<List<CategoryModel>>> getCategories() {
    return _service.getCategories();
  }

  Future<BaseResponse<MenuModel>> createMenu(MenuRequestModel body) {
    return _service.createMenu(body);
  }

  Future<BaseResponse<List<MenuModel>>> getMenus() {
    return _service.getMenus();
  }

  Future<BaseResponse<StorageUploadResponseModel>> uploadFileWithDio({
    required String filePath,
    required String folder,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath,
          filename: filePath.split('/').last),
      'folder': folder,
    });

    final response = await dioClient.post(
      '/storages/upload',
      data: formData,
    );

    return BaseResponse.fromJson(
      response.data,
      (json) =>
          StorageUploadResponseModel.fromJson(json as Map<String, dynamic>),
    );
    // saya buat seperti karna retrofit_generator Dart saat ini belum stabil untuk upload file multipart secara native mass
  }

  Future<void> deleteMenu(int id) {
    return _service.deleteMenu(id);
  }

  Future<BaseResponse<RestaurantModel>> getRestaurant(int id) {
    return _service.getRestaurant(id);
  }

  Future<BaseResponse<RestaurantModel>> updateRestaurant(
      int id, Map<String, dynamic> body) {
    return _service.updateRestaurant(id, body);
  }

  Future<BaseResponse<MenuModel>> updateMenu(int id, MenuRequestModel request) {
    return _service.updateMenu(id, request);
  }
}
