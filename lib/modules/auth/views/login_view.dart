import 'package:flutter/material.dart';
import 'package:game777/core/export.dart';
import 'package:game777/core/routers/router_path.dart';
import 'package:game777/modules/auth/bindings/auth_binding.dart';
import 'package:game777/modules/auth/controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';

class LoginView extends BasePage<AuthController, AuthBinding> {
  LoginView({super.key})
      : super(
          bindingFactory: () => AuthBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, AuthController controller) {
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
              ))
        ],
      ),
    );
  }

  @override
  void onControllerReady(AuthController controller) {
    controller.loadData();
  }
}
