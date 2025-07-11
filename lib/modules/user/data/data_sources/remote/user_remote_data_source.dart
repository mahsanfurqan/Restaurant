import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/services/user_service.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_me_model.dart';

class UserRemoteDataSource {
  final UserService _service;

  const UserRemoteDataSource(this._service);

  Future<UserModel?> getUserById(int id) async {
    try {
      final response = await _service.getUserById(id);
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<UserMeModel> getMe() => _service.getMe();

  Future<BaseResponse<UserModel>> updateUser(
      int id, Map<String, dynamic> body) {
    return _service.updateUser(id, body);
  }
}
