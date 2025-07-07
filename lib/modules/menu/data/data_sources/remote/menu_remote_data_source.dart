import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_response_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

import 'services/menu_service.dart';

class MenuRemoteDataSource {
  final MenuService service;
  MenuRemoteDataSource(this.service);

  Future<BaseResponse<CategoryModel>> getCategoryById(int id) {
    return service.getCategoryById(id);
  }

  Future<MenuResponseModel> createMenu(MenuRequestModel body) {
    return service.createMenu(body);
  }
}
