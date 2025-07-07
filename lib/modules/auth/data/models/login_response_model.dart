import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';

part 'generated/login_response_model.freezed.dart';
part 'generated/login_response_model.g.dart';

@Freezed()
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required TokenModel data,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
