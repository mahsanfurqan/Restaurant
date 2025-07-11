import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/menu_model.freezed.dart';
part 'generated/menu_model.g.dart';

@freezed
class MenuModel with _$MenuModel {
  const factory MenuModel({
    required int id,
    required String createdAt,
    required String name,
    required String description,
    required int price,
    required bool isAvailable,
    @JsonKey(name: 'category') required CategoryModel category,
    @JsonKey(defaultValue: '') required String photoUrl,
  }) = _MenuModel;

  factory MenuModel.fromJson(Map<String, dynamic> json) =>
      _$MenuModelFromJson(json);
}
