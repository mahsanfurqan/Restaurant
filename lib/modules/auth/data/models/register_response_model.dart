import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/register_response_model.freezed.dart';
part 'generated/register_response_model.g.dart';

@Freezed()
class RegisterResponseModel with _$RegisterResponseModel {
  const factory RegisterResponseModel({
    required RegisterDataModel data,
  }) = _RegisterResponseModel;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);
}

@Freezed()
class RegisterDataModel with _$RegisterDataModel {
  const factory RegisterDataModel({
    required int id,
    required String username,
    required String name,
    required String email,
    required bool isAdmin,
    String? role,
    required RestaurantResponseModel restaurant,
  }) = _RegisterDataModel;

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataModelFromJson(json);
}

@Freezed()
class RestaurantResponseModel with _$RestaurantResponseModel {
  const factory RestaurantResponseModel({
    required int id,
    required String createdAt,
    String? name,
    String? address,
    String? description,
    String? phone,
  }) = _RestaurantResponseModel;

  factory RestaurantResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantResponseModelFromJson(json);
}
