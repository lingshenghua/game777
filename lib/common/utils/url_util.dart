import 'dart:collection';
import 'dart:convert';
import 'package:game777/common/export.dart';

class UrlUtil {
  static String buildUrl(String path, Map<String, String>? params) {
    if (params != null && params.isNotEmpty) {
      /// 构建带参数的 URL
      final queryParams = Uri(path: path, queryParameters: params).query;
      return '$path?$queryParams';
    }
    return path;
  }

  static String? sortObjectFields(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return null;

    final treeMap = SplayTreeMap<String, dynamic>.from(params);

    return treeMap.entries.map((entry) {
      String tempValue = jsonEncode(entry.value);
      String encodedValue = tempValue.replaceAll('"', '').replaceAll("'", '');
      return "${entry.key}${CommonConst.equalsSign}$encodedValue";
    }).join(CommonConst.ampersand);
  }

  /// 处理加密的排序参数，先处理 query 字符串，再处理对象数据
  static String sortString(String query, Map<String, dynamic>? data) {
    String finalStr = "";
    String sortQueryString = "";
    String sortDataString = "";

    if (query.isNotEmpty) {
      sortQueryString = _sortUrlString(query);
    }

    if (data != null && data.isNotEmpty) {
      sortDataString = sortObjectFields(data)!;
    }

    finalStr = sortQueryString + sortDataString;
    return finalStr;
  }

  /// 处理 url 参数，按照 key 排序并返回
  static String _sortUrlString(String query) {
    Map<String, String> queryParams = Uri.splitQueryString(query);
    var sortedQueryParams = Map.fromEntries(queryParams.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    return Uri(queryParameters: sortedQueryParams).query;
  }
}
