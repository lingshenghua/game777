import 'package:game777/modules/game/controllers/game_controller.dart';
import 'package:get/get.dart';

class GameBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameController>(() => GameController());
  }
}
