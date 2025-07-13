import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/menu_local_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/remote/menu_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';

import 'menu_repository_test.mocks.dart';

@GenerateMocks([MenuRemoteDataSource, MenuLocalDataSource])
void main() {
  late MenuRepository repository;
  late MockMenuRemoteDataSource mockRemoteDataSource;
  late MockMenuLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMenuRemoteDataSource();
    mockLocalDataSource = MockMenuLocalDataSource();
    repository = MenuRepository(mockRemoteDataSource, mockLocalDataSource);
  });

  group('MenuRepository', () {
    group('fetchCategories', () {
      test('should return cached categories when available', () async {
        // arrange
        final categories = [
          CategoryModel(id: 1, name: 'Category 1', createdAt: '2024-01-01'),
          CategoryModel(id: 2, name: 'Category 2', createdAt: '2024-01-02'),
        ];

        when(mockLocalDataSource.findAllCategories())
            .thenAnswer((_) async => categories);

        // act
        final result = await repository.fetchCategories();

        // assert
        expect(result, isA<Right<Failure, List<CategoryModel>>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (categories) {
            expect(categories.length, 2);
            expect(categories.first.name, 'Category 1');
            expect(categories.last.name, 'Category 2');
          },
        );
        verify(mockLocalDataSource.findAllCategories()).called(1);
        verifyNever(mockRemoteDataSource.getCategories());
      });

      test('should fetch from remote and cache when no local data', () async {
        // arrange
        final categories = [
          CategoryModel(id: 1, name: 'Category 1', createdAt: '2024-01-01'),
        ];
        final response = BaseResponse<List<CategoryModel>>(data: categories);

        when(mockLocalDataSource.findAllCategories())
            .thenAnswer((_) async => []);
        when(mockRemoteDataSource.getCategories())
            .thenAnswer((_) async => response);
        when(mockLocalDataSource.insertAllCategories(any))
            .thenAnswer((_) async => 'Categories inserted');

        // act
        final result = await repository.fetchCategories();

        // assert
        expect(result, isA<Right<Failure, List<CategoryModel>>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (categories) {
            expect(categories.length, 1);
            expect(categories.first.name, 'Category 1');
          },
        );
        verify(mockLocalDataSource.findAllCategories()).called(1);
        verify(mockRemoteDataSource.getCategories()).called(1);
        verify(mockLocalDataSource.insertAllCategories(any)).called(1);
      });
    });

    group('fetchMenus', () {
      test('should return cached menus when available', () async {
        // arrange
        final category =
            CategoryModel(id: 1, name: 'Category 1', createdAt: '2024-01-01');
        final menus = [
          MenuModel(
            id: 1,
            name: 'Menu 1',
            description: 'Description 1',
            price: 10000,
            isAvailable: true,
            category: category,
            photoUrl: 'photo1.jpg',
            createdAt: '2024-01-01',
          ),
        ];

        when(mockLocalDataSource.findAll()).thenAnswer((_) async => menus);

        // act
        final result = await repository.fetchMenus();

        // assert
        expect(result, isA<Right<Failure, BaseResponse<List<MenuModel>>>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (response) {
            expect(response.data?.length, 1);
            expect(response.data?.first.name, 'Menu 1');
          },
        );
        verify(mockLocalDataSource.findAll()).called(1);
        verifyNever(mockRemoteDataSource.getMenus());
      });

      test('should fetch from remote and cache when no local data', () async {
        // arrange
        final category =
            CategoryModel(id: 1, name: 'Category 1', createdAt: '2024-01-01');
        final menus = [
          MenuModel(
            id: 1,
            name: 'Menu 1',
            description: 'Description 1',
            price: 10000,
            isAvailable: true,
            category: category,
            photoUrl: 'photo1.jpg',
            createdAt: '2024-01-01',
          ),
        ];
        final response = BaseResponse<List<MenuModel>>(data: menus);

        when(mockLocalDataSource.findAll()).thenAnswer((_) async => []);
        when(mockRemoteDataSource.getMenus()).thenAnswer((_) async => response);
        when(mockLocalDataSource.insertAll(any))
            .thenAnswer((_) async => 'Menus inserted');

        // act
        final result = await repository.fetchMenus();

        // assert
        expect(result, isA<Right<Failure, BaseResponse<List<MenuModel>>>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (response) {
            expect(response.data?.length, 1);
            expect(response.data?.first.name, 'Menu 1');
          },
        );
        verify(mockLocalDataSource.findAll()).called(1);
        verify(mockRemoteDataSource.getMenus()).called(1);
        verify(mockLocalDataSource.insertAll(any)).called(1);
      });
    });

    group('hasCachedData', () {
      test('should return true when cached data exists', () async {
        // arrange
        final menus = [
          MenuModel(
            id: 1,
            name: 'Menu 1',
            description: 'Description 1',
            price: 10000,
            isAvailable: true,
            category: CategoryModel(
                id: 1, name: 'Category 1', createdAt: '2024-01-01'),
            photoUrl: 'photo1.jpg',
            createdAt: '2024-01-01',
          ),
        ];

        when(mockLocalDataSource.findAll()).thenAnswer((_) async => menus);

        // act
        final result = await repository.hasCachedData();

        // assert
        expect(result, true);
        verify(mockLocalDataSource.findAll()).called(1);
      });

      test('should return false when no cached data exists', () async {
        // arrange
        when(mockLocalDataSource.findAll()).thenAnswer((_) async => []);

        // act
        final result = await repository.hasCachedData();

        // assert
        expect(result, false);
        verify(mockLocalDataSource.findAll()).called(1);
      });
    });

    group('clearCache', () {
      test('should clear all cached data', () async {
        // arrange
        when(mockLocalDataSource.clearAll())
            .thenAnswer((_) async => 'Menus cleared');

        // act
        await repository.clearCache();

        // assert
        verify(mockLocalDataSource.clearAll()).called(1);
      });
    });
  });
}
