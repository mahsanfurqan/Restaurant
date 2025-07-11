import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/restaurant_model.freezed.dart';
part 'generated/restaurant_model.g.dart';

@freezed
class RestaurantModel with _$RestaurantModel {
  const factory RestaurantModel({
    required int id,
    required String createdAt,
    String? name,
    String? address,
    String? description,
    String? phone,
  }) = _RestaurantModel;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
}
