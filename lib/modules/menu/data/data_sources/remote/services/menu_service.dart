import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';

part 'generated/menu_service.g.dart';

@RestApi()
abstract class MenuService {
  factory MenuService(Dio dio, {String? baseUrl}) = _MenuService;

  @GET('/categories')
  Future<BaseResponse<List<CategoryModel>>> getCategories();

  @POST('/menus')
  Future<BaseResponse<MenuModel>> createMenu(@Body() MenuRequestModel body);

  @GET('/menus')
  Future<BaseResponse<List<MenuModel>>> getMenus();

  @DELETE('/menus/{id}')
  Future<void> deleteMenu(@Path('id') int id);

  @GET('/restaurant/{id}')
  Future<BaseResponse<RestaurantModel>> getRestaurant(@Path('id') int id);

  @PATCH('/restaurant/{id}')
  Future<BaseResponse<RestaurantModel>> updateRestaurant(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/menus/{id}')
  Future<BaseResponse<MenuModel>> updateMenu(
    @Path('id') int id,
    @Body() MenuRequestModel request,
  );
}
