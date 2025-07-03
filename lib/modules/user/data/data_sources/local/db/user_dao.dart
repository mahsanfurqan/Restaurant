import 'package:floor/floor.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/entities/user_entity.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Future<List<UserEntity>> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<UserEntity> users);

  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserEntity?> findById(int id);

  @Query('DELETE FROM users')
  Future<void> clearAll();
}
