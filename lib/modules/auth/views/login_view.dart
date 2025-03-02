import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';
import 'package:game777/core/routers/router_path.dart';
import 'package:game777/modules/auth/bindings/login_binding.dart';
import 'package:game777/modules/auth/controllers/login_controller.dart';
import 'package:go_router/go_router.dart';

class LoginView extends BasePage<LoginController, LoginBinding> {
  LoginView({super.key})
      : super(
          bindingFactory: () => LoginBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, LoginController controller) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('LoginView')),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                context.go(RouterPath.gameView);
              },
              child: SmartText(
                "返回",
                type: TextType.button,
              )),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(16),
            child: FormBuilder(
              key: controller.loginFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // 文本输入
                  FormBuilderTextField(
                    name: 'username',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(3),
                      FormBuilderValidators.maxLength(20),
                    ]),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  // 密码输入
                  FormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ]),
                  ),

                  // 复选框
                  FormBuilderCheckbox(
                    name: 'accept_terms',
                    title: Text('我同意用户协议'),
                    validator: FormBuilderValidators.required(),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('提交'),
                    onPressed: () {
                      controller.userLogin();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
