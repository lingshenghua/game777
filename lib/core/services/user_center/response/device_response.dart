import 'package:json_annotation/json_annotation.dart';

part 'device_response.g.dart';

@JsonSerializable()
class DeviceResponse {
  final String deviceId;
  final bool newDevice;
  final String createTime;

  DeviceResponse({this.deviceId = "", this.newDevice = false, this.createTime = ""});

  factory DeviceResponse.fromJson(Map<String, dynamic> json) => _$DeviceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceResponseToJson(this);
}
