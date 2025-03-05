import 'package:game777/common/enums/account_type_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String userAccount;
  final String password;
  final AccountTypeEnum accountTypeEnum;
  final String phoneAreaCode;

  LoginRequest(
      {this.userAccount = "",
      this.password = "",
      this.accountTypeEnum = AccountTypeEnum.email,
      this.phoneAreaCode = ""});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
