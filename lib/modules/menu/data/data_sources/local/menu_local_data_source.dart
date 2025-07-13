import 'package:flutter_boilerplate/core/common/exceptions.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/db/menu_dao.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/db/category_dao.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/menu_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';

class MenuLocalDataSource {
  final MenuDao _menuDao;
  final CategoryDao _categoryDao;

  const MenuLocalDataSource(
    this._menuDao,
    this._categoryDao,
  );

  Future<List<MenuModel>> findAll() async {
    final menuEntities = (await _menuDao.findAll()).reversed;
    final menuModels = <MenuModel>[];

    for (var entity in menuEntities) {
      final categoryEntity =
          await _categoryDao.findById(entity.categoryId ?? 0);
      menuModels.add(MenuModel.fromEntity(entity, category: categoryEntity));
    }

    return menuModels;
  }

  Future<List<CategoryModel>> findAllCategories() async {
    final categoryEntities = await _categoryDao.findAll();
    return categoryEntities
        .map((entity) => CategoryModel.fromEntity(entity))
        .toList();
  }

  Future<String> insertAll(List<MenuModel> menus) async {
    try {
      final categories = <CategoryModel>{};
      final menuEntities = <MenuEntity>[];

      for (var menu in menus) {
        categories.add(menu.category);
        menuEntities.add(menu.toEntity());
      }

      await _categoryDao.insertAll(
          categories.map((category) => category.toEntity()).toList());
      await _menuDao.insertAll(menuEntities);

      return 'Menus inserted';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<String> insertAllCategories(List<CategoryModel> categories) async {
    try {
      final categoryEntities =
          categories.map((category) => category.toEntity()).toList();
      await _categoryDao.insertAll(categoryEntities);
      return 'Categories inserted';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<String> clearAll() async {
    try {
      await _menuDao.clearAll();
      return 'Menus cleared';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<String> clearAllCategories() async {
    try {
      await _categoryDao.clearAll();
      return 'Categories cleared';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
