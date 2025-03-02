import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';
import 'package:game777/modules/activity/bindings/activity_binding.dart';
import 'package:game777/modules/activity/controllers/activity_controller.dart';

class ActivityView extends BasePage<ActivityController, ActivityBinding> {
  ActivityView({super.key})
      : super(
          bindingFactory: () => ActivityBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, ActivityController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('ActivityView')),
      body: Column(
        children: [
          SmartImage.circle(
            size: 100.w,
            url:
                'https://pics1.baidu.com/feed/a5c27d1ed21b0ef4d0d3794da512ecd780cb3eca.jpeg@f_auto?token=b67c2521dd19c9474ce7c763a0f151d5',
          )
        ],
      ),
    );
  }

  @override
  void onControllerReady(ActivityController controller) {
    controller.loadData();
  }
}
