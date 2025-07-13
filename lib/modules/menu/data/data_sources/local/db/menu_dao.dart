import 'package:floor/floor.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/menu_entity.dart';

@dao
abstract class MenuDao {
  @Query('SELECT * FROM menus')
  Future<List<MenuEntity>> findAll();

  @Query('SELECT * FROM menus WHERE id = :id')
  Future<MenuEntity?> findById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<MenuEntity> menus);

  @Query('DELETE FROM menus')
  Future<void> clearAll();
}
