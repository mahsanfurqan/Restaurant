import 'package:floor/floor.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/category_entity.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories')
  Future<List<CategoryEntity>> findAll();

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<CategoryEntity?> findById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<CategoryEntity> categories);

  @Query('DELETE FROM categories')
  Future<void> clearAll();
}
