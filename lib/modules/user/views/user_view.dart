import 'package:flutter/material.dart';
import 'package:game777/core/export.dart';
import 'package:game777/modules/user/bindings/user_binding.dart';
import 'package:game777/modules/user/controllers/user_controller.dart';

class UserView extends BasePage<UserController, UserBinding> {
  UserView({super.key})
      : super(
          bindingFactory: () => UserBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, UserController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('UserView')),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        itemCount: 300,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            height: 100,
            child: Text("$index"),
          );
        },
      ),
    );
  }

  @override
  void onControllerReady(UserController controller) {
    controller.loadData();
  }
}
