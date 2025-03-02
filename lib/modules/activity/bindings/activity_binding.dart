import 'package:game777/modules/activity/controllers/activity_controller.dart';
import 'package:get/get.dart';

class ActivityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(() => ActivityController());
  }
}
