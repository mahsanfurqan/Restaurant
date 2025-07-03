import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/login_dto.freezed.dart';
part 'generated/login_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
class LoginDto with _$LoginDto {
  const factory LoginDto({
    required String username,
    required String password,
  }) = _LoginDto;
}
