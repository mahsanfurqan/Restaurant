import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

import 'services/menu_service.dart';

class MenuRemoteDataSource {
  final MenuService _service;
  const MenuRemoteDataSource(this._service);

  Future<BaseResponse<List<CategoryModel>>> getCategories() {
    return _service.getCategories();
  }

  Future<BaseResponse<MenuModel>> createMenu(MenuRequestModel body) {
    return _service.createMenu(body);
  }

  Future<BaseResponse<List<MenuModel>>> getMenus() {
    return _service.getMenus();
  }
}
