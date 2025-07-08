import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/services/auth_service.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/logout_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_request_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/refresh_token_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_response_wrapper_model.dart';

class AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSource(this._authService);

  Future<TokenModel> login(LoginDto payload) async {
    print('DEBUG: LoginDto toJson: ${payload.toJson()}');

    final response = await _authService.login(payload);
    return response.data;
  }

  Future<BaseResponse<AuthValidateModel>> validateAuth() =>
      _authService.validateAuth();

  Future<void> logout(LogoutDto payload) => _authService.logout(payload);

  Future<RegisterResponseWrapperModel> register(
      RegisterRequestModel payload) async {
    print('DEBUG: RegisterRequestModel toJson: ${payload.toJson()}');

    final response = await _authService.register(payload);
    return response;
  }

  Future<TokenModel> refreshToken(RefreshTokenDto payload) =>
      _authService.refreshToken(payload);
}
