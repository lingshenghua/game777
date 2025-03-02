import 'package:game777/common/export.dart';
import 'package:game777/core/services/export.dart';
import 'package:get/get.dart';

/// 全局控制器
class GlobalController extends GetxController {



  void deviceRegister() async {
    /// 获取设备信息
    ResultBean resultBean = await CommonService.deviceRegister();
    print(resultBean.data);
  }

  @override
  void onInit() {
    super.onInit();
    deviceRegister();
  }
}
