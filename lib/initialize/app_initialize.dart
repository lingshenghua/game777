import 'package:game777/core/export.dart';
import 'package:get/get.dart';

/// 应用初始化
Future<void> appInitialize() async {
  await SafeCache().initialize();
  Get.lazyPut<SystemController>(() => SystemController());
  Get.lazyPut<GlobalController>(() => GlobalController());

  /// 初始化 HTTP 服务
  HttpService.init(
    config: HttpServiceConfig(
      baseUrl: 'http://test.idbattleplat.com:9000',
      enableLogging: true,
    ),
  );
}
