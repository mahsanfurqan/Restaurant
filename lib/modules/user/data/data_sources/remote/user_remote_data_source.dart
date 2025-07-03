import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/services/user_service.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

class UserRemoteDataSource {
  final UserService _service;

  const UserRemoteDataSource(this._service);

  Future<BaseResponse<UserModel>> getUserById(int id) =>
      _service.getUserById(id);
}
