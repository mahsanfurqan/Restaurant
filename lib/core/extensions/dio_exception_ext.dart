import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/shared/responses/base_error_response.dart';

extension DioExceptionExt on DioException {
  BaseErrorResponse? get errorResponse {
    if (error is! BaseErrorResponse) return null;
    final errorResponse = error as BaseErrorResponse;
    return errorResponse;
  }
}
