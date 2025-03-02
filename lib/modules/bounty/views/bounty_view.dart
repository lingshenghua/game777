import 'package:flutter/material.dart';
import 'package:game777/core/export.dart';
import 'package:game777/modules/bounty/bindings/bounty_binding.dart';
import 'package:game777/modules/bounty/controllers/bounty_controller.dart';

class BountyView extends BasePage<BountyController, BountyBinding> {
  BountyView({super.key})
      : super(
          bindingFactory: () => BountyBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, BountyController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('BountyView')),
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
  void onControllerReady(BountyController controller) {
    controller.loadData();
  }
}
