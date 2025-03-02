import 'package:dio/dio.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';

class ErrorHandler {
  final HttpServiceConfig config;

  ErrorHandler(this.config);

  DioException enhanceError(DioException e) {
    String message = config.defaultErrorMessage;
    dynamic errorData;

    if (e.response?.data is Map<String, dynamic>) {
      errorData = e.response!.data as Map<String, dynamic>;
      message = errorData['message'] ?? message;
    }

    return e.copyWith(
      error: message,
      stackTrace: e.stackTrace,
    );
  }

  void validateBusinessResult<T>(BaseResultBean<T> result, Response response) {
    if (result.code != ResponseCodeEnum.success.code) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: result.message ?? '业务请求失败',
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
  }
}
