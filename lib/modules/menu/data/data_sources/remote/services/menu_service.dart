import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_request_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_response_model.dart';

part 'generated/menu_service.g.dart';

@RestApi()
abstract class MenuService {
  factory MenuService(Dio dio, {String? baseUrl}) = _MenuService;

  @GET('/categories/{id}')
  Future<BaseResponse<CategoryModel>> getCategoryById(@Path() int id);

  @POST('/menus')
  Future<MenuResponseModel> createMenu(@Body() MenuRequestModel body);

  // @GET('/menus')
  // Future<HttpResponse<Map<String, dynamic>>> getMenus({
  //   @Query('page') int? page,
  //   @Query('limit') int? limit,
  //   @Query('orderBy') String? orderBy,
  //   @Query('orderDirection') String? orderDirection,
  //   @Query('search') String? search,
  //   @Query('categoryId') String? categoryId,
  //   @Query('isAvailable') bool? isAvailable,
  // });
}
