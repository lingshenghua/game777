import 'package:json_annotation/json_annotation.dart';

part 'page_model.g.dart';

@JsonSerializable()
class PageModel {
  int pageNum;
  int pageSize;

  PageModel({this.pageNum = 1, this.pageSize = 10});

  factory PageModel.fromJson(Map<String, dynamic> json) => _$PageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageModelToJson(this);
}
