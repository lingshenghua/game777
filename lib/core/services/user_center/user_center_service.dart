import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';

/// 应用程序全局接口服务
final class UserCenterService {
  UserCenterService._();

  /// 设备注册
  static Future<DeviceResponse> deviceRegister(DeviceRequest deviceRequest) async {
    BaseResultBean resultBean = await HttpService.instance.request<DeviceResponse>(
      method: HttpMethod.post,
      path: UserCenterApi.deviceRegister,
      data: deviceRequest.toJson(),
      decoder: (json) => DeviceResponse.fromJson(json),
    );
    return resultBean.data;
  }

  /// 用户登录
  static Future<LoginResponse> userLogin(LoginRequest loginRequest) async {
    BaseResultBean resultBean = await HttpService.instance.request<LoginResponse>(
      method: HttpMethod.post,
      path: UserCenterApi.userLogin,
      data: loginRequest.toJson(),
      decoder: (json) => LoginResponse.fromJson(json),
    );
    return resultBean.data;
  }
}
