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
}
