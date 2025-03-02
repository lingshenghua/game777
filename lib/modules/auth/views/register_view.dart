import 'package:flutter/material.dart';
import 'package:game777/core/export.dart';
import 'package:game777/modules/auth/bindings/register_binding.dart';
import 'package:game777/modules/auth/controllers/register_controller.dart';

class RegisterView extends BasePage<RegisterController, RegisterBinding> {
  RegisterView({super.key})
      : super(
          bindingFactory: () => RegisterBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, RegisterController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('RegisterView')),
      body: Container(),
    );
  }
}
