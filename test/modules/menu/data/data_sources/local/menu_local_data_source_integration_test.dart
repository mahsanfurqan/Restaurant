import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/menu_local_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/menu_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/category_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';

void main() {
  group('MenuLocalDataSource Integration Test', () {
    test('should convert MenuModel to Entity and back correctly', () {
      // Arrange
      final category = CategoryModel(
        id: 1,
        name: 'Test Category',
        createdAt: '2024-01-01',
      );

      final menu = MenuModel(
        id: 1,
        name: 'Test Menu',
        description: 'Test Description',
        price: 10000,
        isAvailable: true,
        category: category,
        photoUrl: 'test.jpg',
        createdAt: '2024-01-01',
      );

      // Act
      final entity = menu.toEntity();
      final convertedMenu =
          MenuModel.fromEntity(entity, category: category.toEntity());

      // Assert
      expect(convertedMenu.id, menu.id);
      expect(convertedMenu.name, menu.name);
      expect(convertedMenu.description, menu.description);
      expect(convertedMenu.price, menu.price);
      expect(convertedMenu.isAvailable, menu.isAvailable);
      expect(convertedMenu.category.id, menu.category.id);
      expect(convertedMenu.category.name, menu.category.name);
      expect(convertedMenu.photoUrl, menu.photoUrl);
      expect(convertedMenu.createdAt, menu.createdAt);
    });

    test('should convert CategoryModel to Entity and back correctly', () {
      // Arrange
      final category = CategoryModel(
        id: 1,
        name: 'Test Category',
        createdAt: '2024-01-01',
      );

      // Act
      final entity = category.toEntity();
      final convertedCategory = CategoryModel.fromEntity(entity);

      // Assert
      expect(convertedCategory.id, category.id);
      expect(convertedCategory.name, category.name);
      expect(convertedCategory.createdAt, category.createdAt);
    });

    test('should handle null values in MenuModel.fromEntity', () {
      // Arrange
      final entity = MenuEntity(
        id: 1,
        name: 'Test Menu',
        description: 'Test Description',
        price: 10000,
        isAvailable: true,
        categoryId: 1,
        photoUrl: 'test.jpg',
        createdAt: '2024-01-01',
      );

      // Act
      final menu = MenuModel.fromEntity(entity);

      // Assert
      expect(menu.id, 1);
      expect(menu.name, 'Test Menu');
      expect(menu.description, 'Test Description');
      expect(menu.price, 10000);
      expect(menu.isAvailable, true);
      expect(menu.photoUrl, 'test.jpg');
      expect(menu.createdAt, '2024-01-01');
      // Category should have default values when null
      expect(menu.category.id, 0);
      expect(menu.category.name, '');
      expect(menu.category.createdAt, '');
    });

    test('should handle null values in CategoryModel.fromEntity', () {
      // Arrange
      final entity = CategoryEntity(
        id: 1,
        name: null,
        createdAt: null,
      );

      // Act
      final category = CategoryModel.fromEntity(entity);

      // Assert
      expect(category.id, 1);
      expect(category.name, null);
      expect(category.createdAt, null);
    });
  });
}
