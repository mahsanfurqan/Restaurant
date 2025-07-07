import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/menu_request_model.freezed.dart';
part 'generated/menu_request_model.g.dart';

@freezed
class MenuRequestModel with _$MenuRequestModel {
  const factory MenuRequestModel({
    required String name,
    required String description,
    required String photoUrl,
    required int price,
    required bool isAvailable,
    required int categoryId,
    required int restaurantId,
  }) = _MenuRequestModel;

  factory MenuRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MenuRequestModelFromJson(json);
}
