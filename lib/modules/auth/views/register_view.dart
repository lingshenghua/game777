import 'package:flutter/material.dart';
import 'package:game777/core/export.dart';
import 'package:game777/modules/auth/bindings/auth_binding.dart';
import 'package:game777/modules/auth/controllers/auth_controller.dart';

class RegisterView extends BasePage<AuthController, AuthBinding> {
  RegisterView({super.key})
      : super(
          bindingFactory: () => AuthBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, AuthController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('RegisterView')),
      body: Container(),
    );
  }

  @override
  void onControllerReady(AuthController controller) {
    controller.loadData();
  }
}
