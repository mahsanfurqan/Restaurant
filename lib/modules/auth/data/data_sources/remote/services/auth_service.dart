import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/logout_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _AuthService;

  @POST('/auths/login')
  Future<BaseResponse<TokenModel>> login(@Body() LoginDto payload);

  @GET('/auths/validate')
  Future<BaseResponse<AuthValidateModel>> validateAuth();

  @POST('/auths/logout')
  Future<BaseResponse<void>> logout(@Body() LogoutDto payload);
}
