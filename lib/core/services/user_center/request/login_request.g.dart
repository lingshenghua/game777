// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      userAccount: json['userAccount'] as String? ?? "",
      password: json['password'] as String? ?? "",
      accountTypeEnum: $enumDecodeNullable(_$AccountTypeEnumEnumMap, json['accountTypeEnum']) ?? AccountTypeEnum.email,
      phoneAreaCode: json['phoneAreaCode'] as String? ?? "",
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) => <String, dynamic>{
      'userAccount': instance.userAccount,
      'password': instance.password,
      'accountTypeEnum': _$AccountTypeEnumEnumMap[instance.accountTypeEnum]!,
      'phoneAreaCode': instance.phoneAreaCode,
    };

const _$AccountTypeEnumEnumMap = {
  AccountTypeEnum.phone: 'PHONE',
  AccountTypeEnum.email: 'EMAIL',
  AccountTypeEnum.password: 'PASSWORD',
  AccountTypeEnum.smsCode: 'SMSCODE',
  AccountTypeEnum.underlineSmsCode: 'UNDERLINE_SMSCODE',
};
