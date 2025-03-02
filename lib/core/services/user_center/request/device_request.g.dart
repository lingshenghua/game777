// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRequest _$DeviceRequestFromJson(Map<String, dynamic> json) =>
    DeviceRequest(
      appCodeName: json['appCodeName'] as String? ?? "",
      appName: json['appName'] as String? ?? "",
      appVersion: json['appVersion'] as String? ?? "",
      hardwareConcurrency: json['hardwareConcurrency'] as String? ?? "",
      platform: json['platform'] as String? ?? "",
      vendor: json['vendor'] as String? ?? "",
      deviceUa: json['deviceUa'] as String? ?? "",
      deviceWidth: json['deviceWidth'] as String? ?? "",
      deviceHeight: json['deviceHeight'] as String? ?? "",
      fingerPrintId: json['fingerPrintId'] as String? ?? "",
      language: json['language'] as String? ?? "",
    );

Map<String, dynamic> _$DeviceRequestToJson(DeviceRequest instance) =>
    <String, dynamic>{
      'appCodeName': instance.appCodeName,
      'appName': instance.appName,
      'appVersion': instance.appVersion,
      'hardwareConcurrency': instance.hardwareConcurrency,
      'platform': instance.platform,
      'vendor': instance.vendor,
      'deviceUa': instance.deviceUa,
      'deviceWidth': instance.deviceWidth,
      'deviceHeight': instance.deviceHeight,
      'fingerPrintId': instance.fingerPrintId,
      'language': instance.language,
    };
