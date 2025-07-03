import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/user_payload.freezed.dart';
part 'generated/user_payload.g.dart';

@Freezed(toJson: true, fromJson: false)
class UserPayload with _$UserPayload {
  const factory UserPayload({
    String? username,
    String? name,
    String? password,
  }) = _UserPayload;
}
