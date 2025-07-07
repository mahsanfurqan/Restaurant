import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_model.dart';

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
