import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/db/menu_dao.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/db/category_dao.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/menu_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/category_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/menu_local_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/core/common/exceptions.dart';

import 'menu_local_data_source_test.mocks.dart';

@GenerateMocks([MenuDao, CategoryDao])
void main() {
  late MenuLocalDataSource dataSource;
  late MockMenuDao mockMenuDao;
  late MockCategoryDao mockCategoryDao;

  setUp(() {
    mockMenuDao = MockMenuDao();
    mockCategoryDao = MockCategoryDao();
    dataSource = MenuLocalDataSource(mockMenuDao, mockCategoryDao);
  });

  group('MenuLocalDataSource', () {
    group('findAll', () {
      test('should return list of MenuModel when data exists', () async {
        // arrange
        final categoryEntity = CategoryEntity(
          id: 1,
          name: 'Test Category',
          createdAt: '2024-01-01',
        );
        final menuEntity = MenuEntity(
          id: 1,
          name: 'Test Menu',
          description: 'Test Description',
          price: 10000,
          isAvailable: true,
          categoryId: 1,
          photoUrl: 'test.jpg',
          createdAt: '2024-01-01',
        );

        when(mockMenuDao.findAll()).thenAnswer((_) async => [menuEntity]);
        when(mockCategoryDao.findById(1))
            .thenAnswer((_) async => categoryEntity);

        // act
        final result = await dataSource.findAll();

        // assert
        expect(result, isA<List<MenuModel>>());
        expect(result.length, 1);
        expect(result.first.id, 1);
        expect(result.first.name, 'Test Menu');
        expect(result.first.category.id, 1);
        expect(result.first.category.name, 'Test Category');
        verify(mockMenuDao.findAll()).called(1);
        verify(mockCategoryDao.findById(1)).called(1);
      });

      test('should return empty list when no data exists', () async {
        // arrange
        when(mockMenuDao.findAll()).thenAnswer((_) async => []);

        // act
        final result = await dataSource.findAll();

        // assert
        expect(result, isEmpty);
        verify(mockMenuDao.findAll()).called(1);
        verifyNever(mockCategoryDao.findById(any));
      });
    });

    group('findAllCategories', () {
      test('should return list of CategoryModel when data exists', () async {
        // arrange
        final categoryEntities = [
          CategoryEntity(id: 1, name: 'Category 1', createdAt: '2024-01-01'),
          CategoryEntity(id: 2, name: 'Category 2', createdAt: '2024-01-02'),
        ];

        when(mockCategoryDao.findAll())
            .thenAnswer((_) async => categoryEntities);

        // act
        final result = await dataSource.findAllCategories();

        // assert
        expect(result, isA<List<CategoryModel>>());
        expect(result.length, 2);
        expect(result.first.id, 1);
        expect(result.first.name, 'Category 1');
        expect(result.last.id, 2);
        expect(result.last.name, 'Category 2');
        verify(mockCategoryDao.findAll()).called(1);
      });

      test('should return empty list when no categories exist', () async {
        // arrange
        when(mockCategoryDao.findAll()).thenAnswer((_) async => []);

        // act
        final result = await dataSource.findAllCategories();

        // assert
        expect(result, isEmpty);
        verify(mockCategoryDao.findAll()).called(1);
      });
    });

    group('insertAll', () {
      test('should insert menus and categories successfully', () async {
        // arrange
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

        when(mockCategoryDao.insertAll(any)).thenAnswer((_) async => [1]);
        when(mockMenuDao.insertAll(any)).thenAnswer((_) async => [1]);

        // act
        final result = await dataSource.insertAll([menu]);

        // assert
        expect(result, 'Menus inserted');
        verify(mockCategoryDao.insertAll(any)).called(1);
        verify(mockMenuDao.insertAll(any)).called(1);
      });

      test('should throw DatabaseException when insertion fails', () async {
        // arrange
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

        when(mockCategoryDao.insertAll(any))
            .thenThrow(Exception('Database error'));

        // act & assert
        expect(
          () => dataSource.insertAll([menu]),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('insertAllCategories', () {
      test('should insert categories successfully', () async {
        // arrange
        final categories = [
          CategoryModel(id: 1, name: 'Category 1', createdAt: '2024-01-01'),
          CategoryModel(id: 2, name: 'Category 2', createdAt: '2024-01-02'),
        ];

        when(mockCategoryDao.insertAll(any)).thenAnswer((_) async => [1, 2]);

        // act
        final result = await dataSource.insertAllCategories(categories);

        // assert
        expect(result, 'Categories inserted');
        verify(mockCategoryDao.insertAll(any)).called(1);
      });

      test('should throw DatabaseException when insertion fails', () async {
        // arrange
        final categories = [
          CategoryModel(id: 1, name: 'Category 1', createdAt: '2024-01-01'),
        ];

        when(mockCategoryDao.insertAll(any))
            .thenThrow(Exception('Database error'));

        // act & assert
        expect(
          () => dataSource.insertAllCategories(categories),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('clearAll', () {
      test('should clear all menus successfully', () async {
        // arrange
        when(mockMenuDao.clearAll()).thenAnswer((_) async => null);

        // act
        final result = await dataSource.clearAll();

        // assert
        expect(result, 'Menus cleared');
        verify(mockMenuDao.clearAll()).called(1);
      });

      test('should throw DatabaseException when clearing fails', () async {
        // arrange
        when(mockMenuDao.clearAll()).thenThrow(Exception('Database error'));

        // act & assert
        expect(
          () => dataSource.clearAll(),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('clearAllCategories', () {
      test('should clear all categories successfully', () async {
        // arrange
        when(mockCategoryDao.clearAll()).thenAnswer((_) async => null);

        // act
        final result = await dataSource.clearAllCategories();

        // assert
        expect(result, 'Categories cleared');
        verify(mockCategoryDao.clearAll()).called(1);
      });

      test('should throw DatabaseException when clearing fails', () async {
        // arrange
        when(mockCategoryDao.clearAll()).thenThrow(Exception('Database error'));

        // act & assert
        expect(
          () => dataSource.clearAllCategories(),
          throwsA(isA<DatabaseException>()),
        );
      });
    });
  });
}
