import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_me_model.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepository(this._remoteDataSource);

  Future<UserMeModel> getMe() => _remoteDataSource.getMe();

  Future<UserModel?> updateUser(int id, Map<String, dynamic> body) async {
    try {
      final response = await _remoteDataSource.updateUser(id, body);
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserById(int id) => _remoteDataSource.getUserById(id);
}
