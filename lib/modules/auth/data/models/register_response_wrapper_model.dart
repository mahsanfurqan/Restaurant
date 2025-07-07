import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/register_response_model.dart';

part 'generated/register_response_wrapper_model.freezed.dart';
part 'generated/register_response_wrapper_model.g.dart';

@freezed
class RegisterResponseWrapperModel with _$RegisterResponseWrapperModel {
  const factory RegisterResponseWrapperModel({
    RegisterDataModel? data,
  }) = _RegisterResponseWrapperModel;

  factory RegisterResponseWrapperModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseWrapperModelFromJson(json);
}
