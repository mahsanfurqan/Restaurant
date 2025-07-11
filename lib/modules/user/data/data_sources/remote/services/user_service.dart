import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_me_model.dart';

part 'generated/user_service.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _UserService;

  @GET('/user/{id}')
  Future<BaseResponse<UserModel>> getUserById(@Path() int id);

  @GET('/auth/me')
  Future<UserMeModel> getMe();

  @PATCH('/user/{id}')
  Future<BaseResponse<UserModel>> updateUser(
      @Path() int id, @Body() Map<String, dynamic> body);
}
