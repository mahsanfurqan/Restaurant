import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/services/auth_service.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/logout_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_request_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/refresh_token_dto.dart';

class AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSource(this._authService);

  Future<BaseResponse<TokenModel>> login(LoginDto payload) async {
    print('DEBUG: LoginDto toJson: ${payload.toJson()}');
    return await _authService.login(payload);
  }

  Future<BaseResponse<AuthValidateModel>> validateAuth() =>
      _authService.validateAuth();

  Future<BaseResponse<void>> logout(LogoutDto payload) =>
      _authService.logout(payload);

  Future<BaseResponse<void>> register(RegisterRequestModel payload) async {
    print('DEBUG: RegisterRequestModel toJson: ${payload.toJson()}');
    return await _authService.register(payload);
  }

  Future<BaseResponse<TokenModel>> refreshToken(RefreshTokenDto payload) =>
      _authService.refreshToken(payload);
}
