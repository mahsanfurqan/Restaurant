import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/category_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/category_model.freezed.dart';
part 'generated/category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    String? name,
    String? createdAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id ?? 0,
      name: entity.name,
      createdAt: entity.createdAt,
    );
  }
}

extension CategoryModelExt on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      createdAt: createdAt,
    );
  }
}
