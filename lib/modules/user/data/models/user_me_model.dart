import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/user_me_model.freezed.dart';
part 'generated/user_me_model.g.dart';

@Freezed()
class UserMeModel with _$UserMeModel {
  const factory UserMeModel({
    required int id,
    required String username,
    required String name,
    required String email,
    required String role,
    required bool isAdmin,
    required int restaurantId,
  }) = _UserMeModel;

  factory UserMeModel.fromJson(Map<String, dynamic> json) =>
      _$UserMeModelFromJson(json);
}
