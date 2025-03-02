import 'package:game777/core/export.dart';
import 'package:get/get.dart';

/// 全局控制器
class GlobalController extends GetxController {
  final SafeCache safeCache = SafeCache();

  RxString deviceId = "".obs;

  /// 注册设备
  void deviceRegister() async {
    deviceId.value = safeCache.get(CacheKeyConst.deviceId) ?? "";
    if (deviceId.value.isNotEmpty) return;

    /// 获取设备信息
    DeviceResponse response = await UserCenterService.deviceRegister(DeviceRequest(
        appCodeName: "Mozilla",
        appName: "Netscape",
        appVersion: "1.0.2",
        hardwareConcurrency: '20',
        platform: "Win32",
        vendor: "Google Inc.",
        deviceUa: "HUAWEI P30",
        deviceWidth: '750',
        deviceHeight: '1624',
        fingerPrintId: "19ea7b1abad9d629acd88c520794be00",
        language: "pt-br"));
    if (response.deviceId.isEmpty) return;
    safeCache.set(key: CacheKeyConst.deviceId, value: response.deviceId);
    deviceId.value = response.deviceId;
  }

  @override
  void onInit() {
    super.onInit();
    deviceRegister();
  }
}
