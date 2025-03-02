import 'package:flutter/material.dart';
import 'package:game777/core/export.dart';
import 'package:game777/core/routers/router_path.dart';
import 'package:game777/main_view.dart';
import 'package:game777/modules/acting/views/acting_view.dart';
import 'package:game777/modules/activity/views/activity_view.dart';
import 'package:game777/modules/auth/auth_routes.dart';
import 'package:game777/modules/bounty/views/bounty_view.dart';
import 'package:game777/modules/game/views/game_view.dart';
import 'package:game777/modules/user/views/user_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,

    /// 启用路由调试日志
    initialLocation: RouterPath.gameView,
    routes: [
      /// 根路径重定向
      GoRoute(
        path: '/',
        redirect: (context, state) => RouterPath.gameView,
      ),

      /// 主导航容器
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainView(child: navigationShell);
        },
        branches: [
          _buildTabBranch(
            path: RouterPath.gameView,
            screen: GameView(),
            defaultBranch: true,
          ),
          _buildTabBranch(
            path: RouterPath.bountyView,
            screen: BountyView(),
          ),
          _buildTabBranch(
            path: RouterPath.actingView,
            screen: ActingView(),
          ),
          _buildTabBranch(
            path: RouterPath.activityView,
            screen: ActivityView(),
          ),
          _buildTabBranch(
            path: RouterPath.userView,
            screen: UserView(),
          ),
        ],
      ),

      /// 用户认证
      ...AuthRoutes.routes,
    ],
    redirect: (context, state) {
      /// 需要登录的路径列表
      final protectedPaths = [
        RouterPath.userView,
        RouterPath.bountyView,
        RouterPath.actingView,
        RouterPath.activityView,
      ];

      /// 需要登录的路径列表
      if (protectedPaths.contains(state.fullPath)) {
        return RouterPath.loginView;
      }
      return null;
    },
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text('找不到页面: ${state.error?.message ?? state.uri.path}'),
        ),
      ),
    ),
  );

  /// 分支构建工厂方法
  static StatefulShellBranch _buildTabBranch({
    required String path,
    required Widget screen,
    bool defaultBranch = false,
  }) {
    return StatefulShellBranch(
      navigatorKey: GlobalKey<NavigatorState>(
        debugLabel: 'Branch_${path.replaceAll('/', '')}',
      ),
      routes: [
        GoRoute(
          path: path,
          redirect: defaultBranch
              ? (context, state) {
                  /// 处理根路径重定向
                  if (state.uri.path == '/') return path;
                  return null;
                }
              : null,
          pageBuilder: (context, state) => MaterialPage(
            key: ValueKey(path),
            restorationId: path,
            child: KeepAliveWrapper(child: screen),
          ),
        ),
      ],
    );
  }
}
