import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_model.dart';
import 'package:flutter_boilerplate/shared/responses/meta_response.dart';

part 'generated/menu_response_model.freezed.dart';
part 'generated/menu_response_model.g.dart';

@Freezed()
class MenuResponseModel with _$MenuResponseModel {
  const factory MenuResponseModel({
    required MenuModel data,
  }) = _MenuResponseModel;

  factory MenuResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MenuResponseModelFromJson(json);
}

@freezed
class MenuListResponseModel with _$MenuListResponseModel {
  const factory MenuListResponseModel({
    required List<MenuModel> data,
    required MetaResponse meta,
  }) = _MenuListResponseModel;

  factory MenuListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MenuListResponseModelFromJson(json);
}
