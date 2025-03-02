// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceResponse _$DeviceResponseFromJson(Map<String, dynamic> json) =>
    DeviceResponse(
      deviceId: json['deviceId'] as String? ?? "",
      newDevice: json['newDevice'] as bool? ?? false,
      createTime: json['createTime'] as String? ?? "",
    );

Map<String, dynamic> _$DeviceResponseToJson(DeviceResponse instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'newDevice': instance.newDevice,
      'createTime': instance.createTime,
    };
