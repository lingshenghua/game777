import 'package:game777/modules/acting/controllers/acting_controller.dart';
import 'package:get/get.dart';

class ActingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActingController>(() => ActingController());
  }
}
