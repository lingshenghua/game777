import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormBuilderState>();

  Future<void> userLogin() async {
    if (loginFormKey.currentState!.saveAndValidate()) {
      /// 获取表单数据
      final formData = loginFormKey.currentState!.value;
      print(formData);
      LoginResponse loginResponse = await UserCenterService.userLogin(
          LoginRequest(accountTypeEnum: AccountTypeEnum.EMAIL, userAccount: "10086@qq.com", password: "123456"));
      print(loginResponse.token);
      print(loginResponse.token);
      print(loginResponse.token);
    }
  }
}
