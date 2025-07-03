import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/user_service.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _UserService;

  @GET('/users/{id}')
  Future<BaseResponse<UserModel>> getUserById(@Path() int id);
}
