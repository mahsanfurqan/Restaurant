import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/repositories/user_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';

class SettingsRepository {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final MenuRepository _menuRepository;

  const SettingsRepository(
    this._authRepository,
    this._userRepository,
    this._menuRepository,
  );

  Future<Either<Failure, void>> logout() async {
    try {
      await _authRepository.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(null));
    }
  }

  Future<Either<Failure, RestaurantModel?>> getRestaurant(
      int restaurantId) async {
    try {
      final result = await _menuRepository.getRestaurant(restaurantId);
      return result.fold(
        (failure) => Left(failure),
        (response) => Right(response.data),
      );
    } catch (e) {
      return Left(ServerFailure(null));
    }
  }

  Future<Either<Failure, BaseResponse<RestaurantModel>>> updateRestaurant(
    int restaurantId,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _menuRepository.updateRestaurant(restaurantId, body);
      return result;
    } catch (e) {
      return Left(ServerFailure(null));
    }
  }

  Future<Either<Failure, dynamic>> updateUserProfile(
    int userId,
    Map<String, dynamic> body,
  ) async {
    try {
      final updatedUser = await _userRepository.updateUser(userId, body);
      if (updatedUser != null) {
        return Right(updatedUser);
      }
      return Left(ServerFailure(null));
    } catch (e) {
      return Left(ServerFailure(null));
    }
  }

  Future<Either<Failure, dynamic>> getUserById(int userId) async {
    try {
      final user = await _userRepository.getUserById(userId);
      if (user != null) {
        return Right(user);
      }
      return Left(ServerFailure(null));
    } catch (e) {
      return Left(ServerFailure(null));
    }
  }
}
