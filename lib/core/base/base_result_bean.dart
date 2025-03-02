import 'package:game777/core/export.dart';

class BaseResultBean<T> {
  final int? code;
  final String? message;
  final dynamic data;

  BaseResultBean({this.code, this.message, this.data});

  factory BaseResultBean.fromJson({required Map<String, dynamic> json, T Function(dynamic)? fromJsonT}) {
    final int? code = json[CommonConst.responseCode];
    final String? message = json[CommonConst.responseMessage] ?? CommonConst.emptyString;

    dynamic data = json[CommonConst.responseData];

    if (fromJsonT == null) {
      return BaseResultBean<T>(
        code: code,
        message: message,
        data: data,
      );
    }

    return BaseResultBean<T>(
      code: code,
      message: message,
      data: fromJsonT(data),
    );
  }
}
