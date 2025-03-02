import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';

/// 应用程序全局接口服务
final class CommonService {
  CommonService._();

  /// 设备注册
  static Future<ResultBean> deviceRegister() async {
    ResultBean resultBean = await HttpService().request(method: HttpMethod.post, path: ApiConst.deviceRegister, data: {
      'appCodeName': "Mozilla",
      'appName': "Netscape",
      'appVersion': "1.0.2",
      'hardwareConcurrency': 20,
      'platform': "Win32",
      'vendor': "Google Inc.",
      'deviceUa': "HUAWEI P30",
      'deviceWidth': 750,
      'deviceHeight': 1624,
      'fingerPrintId': "19ea7b1abad9d629acd88c520794be00",
      'language': "pt-br"
    });
    return resultBean;
  }
}
