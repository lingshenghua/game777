import 'package:game777/core/export.dart';
import 'package:get/get.dart';

/// 应用初始化
Future<void> appInitialize() async {
  await SafeCache().initialize();
  Get.lazyPut<SystemController>(() => SystemController());
  Get.lazyPut<GlobalController>(() => GlobalController());
}
