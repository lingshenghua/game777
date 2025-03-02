import 'package:game777/common/export.dart';
import 'package:game777/core/routers/router_path.dart';
import 'package:game777/modules/auth/views/login_view.dart';
import 'package:game777/modules/auth/views/register_view.dart';
import 'package:go_router/go_router.dart';

class AuthRoutes {
  static final List<GoRoute> routes = [
    /// 登录
    leftInRightOut(RouterPath.loginView, (context, state) {
      return LoginView();
    }),

    /// 注册
    leftInRightOut(RouterPath.registerView, (context, state) {
      return RegisterView();
    }),
  ];
}
