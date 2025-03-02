import 'package:game777/modules/bounty/controllers/bounty_controller.dart';
import 'package:get/get.dart';

class BountyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BountyController>(() => BountyController());
  }
}
