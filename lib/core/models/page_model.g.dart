// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageModel _$PageModelFromJson(Map<String, dynamic> json) => PageModel(
      pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$PageModelToJson(PageModel instance) => <String, dynamic>{
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
    };
