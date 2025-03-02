import 'package:game777/common/export.dart';

class PageInfo<T> {
  final int currentPage;
  final int pageSize;
  final int total;
  final List<T> records;

  PageInfo({
    this.currentPage = 0,
    this.pageSize = 10,
    this.total = 0,
    required this.records,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json, {isRecords = false}) {
    return PageInfo<T>(
      currentPage: json[CommonConst.currentPage] ?? 0,
      pageSize: json[CommonConst.pageSize] ?? 10,
      total: int.tryParse(json[CommonConst.total].toString()) ?? 0,
      records: isRecords ? json[CommonConst.records] ?? [] : [],
    );
  }

  PageInfo<T> copyWith({
    int? currentPage,
    int? pageSize,
    int? total,
    List<T>? records,
  }) {
    return PageInfo<T>(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      records: records ?? this.records,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      CommonConst.currentPage: currentPage,
      CommonConst.pageSize: pageSize,
      CommonConst.responseData: total,
      CommonConst.records: records,
    };
  }
}
