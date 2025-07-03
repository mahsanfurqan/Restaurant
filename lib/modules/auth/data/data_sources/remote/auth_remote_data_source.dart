import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/services/auth_service.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/logout_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

class AuthRemoteDataSource {
  final AuthService _authService;

  const AuthRemoteDataSource(this._authService);

  Future<BaseResponse<TokenModel>> login(LoginDto payload) =>
      _authService.login(payload);

  Future<BaseResponse<AuthValidateModel>> validateAuth() =>
      _authService.validateAuth();

  Future<void> logout(LogoutDto payload) => _authService.logout(payload);
}
