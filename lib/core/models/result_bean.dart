import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';

class ResultBean<T> {
  final int? code;
  final String? message;
  final dynamic data;

  ResultBean({this.code, this.message, this.data});

  /// 通用的 fromJson 方法，使用 fail-fast 模式
  factory ResultBean.fromJson({required Map<String, dynamic> json, T Function(dynamic)? fromJsonT}) {
    /// 1. 必须有 code 和 message，缺少时抛出异常
    final int? code = json[CommonConst.responseCode];
    final String? message = json[CommonConst.responseMessage] ?? CommonConst.emptyString;

    if (code == null) {
      throw ArgumentError('Code cannot be null');
    }

    /// 2. 必须有 data 字段，若没有则抛出异常
    dynamic data = json[CommonConst.responseData];

    /// 3. 如果 fromJsonT 是 null，直接返回 ResultBean
    if (fromJsonT == null) {
      return ResultBean<T>(
        code: code,
        message: message,
        data: data,
      );
    }

    /// 4. 如果 data 是基础类型（String、int、double、bool），直接返回
    else if (data is String || data is int || data is double || data is bool) {
      return ResultBean<T>(
        code: code,
        message: message,
        data: data,
      );
    } else {
      /// 5. 如果 data 是 List 类型，递归解析为 List<T>
      if (data is List) {
        return ResultBean<T>(
          code: code,
          message: message,
          data: fromJsonList<T>(data, fromJsonT),
        );
      }

      /// 6. 如果 data 是分页类型 Map，处理分页数据
      else if (data is Map<String, dynamic> && data.containsKey(CommonConst.currentPage)) {
        final pageInfo = PageInfo<T>.fromJson(data);
        final List<T> records = _parseRecords(pageInfo, data, fromJsonT);
        return ResultBean<T>(
          code: code,
          message: message,
          data: pageInfo.copyWith(records: records),
        );
      }

      /// 7. 如果 data 是单个对象类型，递归解析为 T
      else if (data is Map<String, dynamic>) {
        return ResultBean<T>(
          code: code,
          message: message,
          data: fromJsonT(data),
        );
      } else {
        /// 其他情况（比如 null 或其他类型）
        return ResultBean<T>(
          code: code,
          message: message,
          data: null,
        );
      }
    }
  }

  /// 用于处理 List 类型的通用方法
  static List<T> fromJsonList<T>(List<dynamic> data, T Function(Map<String, dynamic>) fromJsonT) {
    if (data.isEmpty) {
      return <T>[];
    }
    return data.map<T>((item) {
      if (item is Map<String, dynamic>) {
        return fromJsonT(item);
      } else {
        throw ArgumentError('List item is not of expected Map type');
      }
    }).toList();
  }

  /// 解析分页中的 records
  static List<T> _parseRecords<T>(
    PageInfo<T> pageInfo,
    Map<String, dynamic> data,
    T Function(dynamic) fromJsonT,
  ) {
    final records = data[CommonConst.records] ?? [];
    if (records.isEmpty) {
      return <T>[];
    }
    return records.map<T>((item) {
      if (item is Map<String, dynamic>) {
        return fromJsonT(item);
      } else {
        throw ArgumentError('Record item is not of expected Map type');
      }
    }).toList();
  }
}
