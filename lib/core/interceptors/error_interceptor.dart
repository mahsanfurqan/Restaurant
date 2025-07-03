import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/shared/responses/base_error_response.dart';
import 'package:flutter_boilerplate/shared/responses/error_detail_response.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    BaseErrorResponse errorResponse;

    try {
      if (err.response?.data != null) {
        errorResponse = BaseErrorResponse.fromJson(err.response?.data);
        debugPrint('errorResponse: $errorResponse');
      } else {
        errorResponse = BaseErrorResponse(
          errors: [
            ErrorDetailResponse(
              detail: AppLocalizations.unexpectedErrorMessage(),
            ),
          ],
        );
      }
    } catch (e) {
      errorResponse = BaseErrorResponse(
        errors: [
          ErrorDetailResponse(
            detail: AppLocalizations.unexpectedErrorMessage(),
          ),
        ],
      );
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: DioExceptionType.badResponse,
        error: errorResponse,
      ),
    );
  }
}
