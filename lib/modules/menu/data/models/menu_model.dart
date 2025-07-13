import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/menu_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/category_entity.dart';
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

  factory MenuModel.fromEntity(MenuEntity entity, {CategoryEntity? category}) {
    return MenuModel(
      id: entity.id ?? 0,
      createdAt: entity.createdAt ?? '',
      name: entity.name ?? '',
      description: entity.description ?? '',
      price: entity.price ?? 0,
      isAvailable: entity.isAvailable ?? false,
      category: category != null
          ? CategoryModel.fromEntity(category)
          : CategoryModel(id: 0, createdAt: '', name: ''),
      photoUrl: entity.photoUrl ?? '',
    );
  }
}

extension MenuModelExt on MenuModel {
  MenuEntity toEntity() {
    return MenuEntity(
      id: id,
      createdAt: createdAt,
      name: name,
      description: description,
      price: price,
      isAvailable: isAvailable,
      categoryId: category.id,
      photoUrl: photoUrl,
    );
  }
}
