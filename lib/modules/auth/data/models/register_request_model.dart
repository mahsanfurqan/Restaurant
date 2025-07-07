import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/register_request_model.freezed.dart';
part 'generated/register_request_model.g.dart';

@Freezed()
class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    required String username,
    required String name,
    required String email,
    required String password,
    required RestaurantModel restaurant,
  }) = _RegisterRequestModel;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);
}

@Freezed()
class RestaurantModel with _$RestaurantModel {
  const factory RestaurantModel({
    required String name,
    required String address,
    required String description,
    required String phone,
  }) = _RestaurantModel;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
}
