import 'package:flutter_boilerplate/shared/responses/meta_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/base_response.freezed.dart';
part 'generated/base_response.g.dart';

@Freezed(genericArgumentFactories: true)
class BaseResponse<T> with _$BaseResponse<T> {
  const factory BaseResponse({
    T? data,
    MetaResponse? meta,
  }) = _BaseResponse<T>;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      BaseResponse(
        data: json['data'] == null ? null : fromJsonT(json['data']),
        meta: json['meta'] == null
            ? null
            : MetaResponse.fromJson(json['meta'] as Map<String, dynamic>),
      );
}
