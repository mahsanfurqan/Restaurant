import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/logout_dto.freezed.dart';
part 'generated/logout_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
class LogoutDto with _$LogoutDto {
  const factory LogoutDto({
    required String refreshToken,
  }) = _LogoutDto;
}
