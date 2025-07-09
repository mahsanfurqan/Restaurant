import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/logout_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_request_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/refresh_token_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_response_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_response_wrapper_model.dart';

part 'generated/auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _AuthService;

  @POST('/auth/login')
  Future<BaseResponse<TokenModel>> login(@Body() LoginDto payload);

  @GET('/auth/validate')
  Future<BaseResponse<AuthValidateModel>> validateAuth();

  @POST('/auths/logout')
  Future<BaseResponse<void>> logout(@Body() LogoutDto payload);

  @POST('/auth/register')
  Future<BaseResponse<void>> register(@Body() RegisterRequestModel payload);

  @POST('/auth/refresh-token')
  Future<BaseResponse<TokenModel>> refreshToken(
      @Body() RefreshTokenDto payload);
}
