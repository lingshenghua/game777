import 'package:json_annotation/json_annotation.dart';

part 'device_request.g.dart';

@JsonSerializable()
class DeviceRequest {
  final String appCodeName;
  final String appName;
  final String appVersion;
  final String hardwareConcurrency;
  final String platform;
  final String vendor;
  final String deviceUa;
  final String deviceWidth;
  final String deviceHeight;
  final String fingerPrintId;
  final String language;

  DeviceRequest(
      {this.appCodeName = "",
      this.appName = "",
      this.appVersion = "",
      this.hardwareConcurrency = "",
      this.platform = "",
      this.vendor = "",
      this.deviceUa = "",
      this.deviceWidth = "",
      this.deviceHeight = "",
      this.fingerPrintId = "",
      this.language = ""});

  factory DeviceRequest.fromJson(Map<String, dynamic> json) => _$DeviceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceRequestToJson(this);
}
