import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:flutter_boilerplate/modules/menu/presentation/controllers/view_menu_controller.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';

import 'view_menu_controller_test.mocks.dart';

@GenerateMocks([MenuRepository])
void main() {
  late ViewMenuController controller;
  late MockMenuRepository mockRepository;

  setUp(() {
    mockRepository = MockMenuRepository();
    controller = ViewMenuController(mockRepository);
    // Don't call onInit to avoid automatic fetchMenus call
  });

  tearDown(() {
    Get.reset();
  });

  group('ViewMenuController', () {
    test('should initialize with initial state', () {
      expect(controller.menuState, isA<ResultInitial<List<MenuModel>>>());
      expect(controller.isOfflineMode, false);
      expect(controller.hasCachedData, false);
    });

    test('should fetch menus successfully', () async {
      // Arrange
      final menus = [
        MenuModel(
          id: 1,
          name: 'Test Menu 1',
          description: 'Test Description 1',
          price: 10000,
          isAvailable: true,
          photoUrl: '',
          category: CategoryModel(id: 1, name: 'Test Category'),
          createdAt: '2024-01-01T00:00:00Z',
        ),
        MenuModel(
          id: 2,
          name: 'Test Menu 2',
          description: 'Test Description 2',
          price: 20000,
          isAvailable: true,
          photoUrl: '',
          category: CategoryModel(id: 1, name: 'Test Category'),
          createdAt: '2024-01-01T00:00:00Z',
        ),
      ];

      when(mockRepository.fetchMenus()).thenAnswer((_) async => Right(menus));
      when(mockRepository.hasCachedData()).thenAnswer((_) async => false);

      // Act
      await controller.fetchMenus();

      // Assert
      expect(controller.menuState, isA<ResultSuccess<List<MenuModel>>>());
      expect(controller.isOfflineMode, false);
      expect(controller.hasCachedData, false);
    });

    test('should handle offline mode when network fails but cache exists',
        () async {
      // Arrange
      final cachedMenus = [
        MenuModel(
          id: 1,
          name: 'Cached Menu 1',
          description: 'Cached Description 1',
          price: 10000,
          isAvailable: true,
          photoUrl: '',
          category: CategoryModel(id: 1, name: 'Test Category'),
          createdAt: '2024-01-01T00:00:00Z',
        ),
        MenuModel(
          id: 2,
          name: 'Cached Menu 2',
          description: 'Cached Description 2',
          price: 20000,
          isAvailable: true,
          photoUrl: '',
          category: CategoryModel(id: 1, name: 'Test Category'),
          createdAt: '2024-01-01T00:00:00Z',
        ),
      ];

      when(mockRepository.fetchMenus())
          .thenAnswer((_) async => Left(ServerFailure(null)));
      when(mockRepository.hasCachedData()).thenAnswer((_) async => true);
      when(mockRepository.fetchMenus())
          .thenAnswer((_) async => Right(cachedMenus));

      // Act
      await controller.fetchMenus();

      // Assert
      expect(controller.menuState, isA<ResultSuccess<List<MenuModel>>>());
      expect(controller.isOfflineMode, true);
      expect(controller.hasCachedData, true);
    });

    test('should handle complete failure when no cache exists', () async {
      // Arrange
      when(mockRepository.fetchMenus())
          .thenAnswer((_) async => Left(ServerFailure(null)));
      when(mockRepository.hasCachedData()).thenAnswer((_) async => false);

      // Act
      await controller.fetchMenus();

      // Assert
      expect(controller.menuState, isA<ResultFailed>());
      expect(controller.isOfflineMode, false);
      expect(controller.hasCachedData, false);
    });

    test('should delete menu successfully', () async {
      // Arrange
      when(mockRepository.deleteMenu(1))
          .thenAnswer((_) async => const Right('Menu deleted'));

      // Act
      final result = await controller.deleteMenu(1);

      // Assert
      expect(result, true);
      verify(mockRepository.deleteMenu(1)).called(1);
    });

    test('should clear cache successfully', () async {
      // Arrange
      when(mockRepository.clearCache()).thenAnswer((_) async {});

      // Act
      await controller.clearCache();

      // Assert
      expect(controller.hasCachedData, false);
      verify(mockRepository.clearCache()).called(1);
    });
  });
}
