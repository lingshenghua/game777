import 'package:flutter/material.dart';
import 'package:game777/core/export.dart';
import 'package:game777/modules/acting/bindings/acting_binding.dart';
import 'package:game777/modules/acting/controllers/acting_controller.dart';

class ActingView extends BasePage<ActingController, ActingBinding> {
  ActingView({super.key})
      : super(
          bindingFactory: () => ActingBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, ActingController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('ActingView')),
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
  void onControllerReady(ActingController controller) {
    controller.loadData();
  }
}
