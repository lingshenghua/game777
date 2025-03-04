import 'package:easy_refresh/easy_refresh.dart';
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
      appBar: AppBar(title: const Text('BountyView'),actions: [
        GestureDetector(
          onTap: () async {
            controller.easyRefreshController.callRefresh();
          },
          child: Text("点击"),
        )
      ],),
      body: EasyRefresh(
        controller: controller.easyRefreshController,
        onRefresh: () async {
          await controller.refreshData();
        },
        onLoad: () async {
          await controller.loadMoreData();
        },
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
        ),
      ),
    );
  }

  @override
  void onControllerReady(BountyController controller) {
    controller.loadData();
  }
}
