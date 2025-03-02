import 'package:flutter/material.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/routers/router_path.dart';
import 'package:go_router/go_router.dart';

/// 应用主框架
class MainView extends StatefulWidget {
  final Widget child;

  const MainView({super.key, required this.child});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    I10nUtil().init(context);
    final currentIndex = _getCurrentIndex(context);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: I10nUtil.tr("31017717")),
          BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: I10nUtil.tr("31017718")),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: I10nUtil.tr("31017719")),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: I10nUtil.tr("31017720")),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: I10nUtil.tr("31017721")),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case RouterPath.gameView:
        return 0;
      case RouterPath.bountyView:
        return 1;
      case RouterPath.activityView:
        return 2;
      case RouterPath.actingView:
        return 3;
      case RouterPath.userView:
        return 4;
      default:
        return 0;
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouterPath.gameView);
        break;
      case 1:
        context.go(RouterPath.bountyView);
        break;
      case 2:
        context.go(RouterPath.activityView);
        break;
      case 3:
        context.go(RouterPath.actingView);
        break;
      case 4:
        context.go(RouterPath.userView);
        break;
    }
  }
}
