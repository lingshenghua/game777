import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/routers/router_path.dart';
import 'package:go_router/go_router.dart';

class NavConfig {
  static const List<NavItem> items = [
    NavItem(
      route: RouterPath.gameView,
      iconPath: 'assets/images/app/home.png',
      activeIconPath: 'assets/images/app/active_home.png',
      labelKey: "31017717",
    ),
    NavItem(
      route: RouterPath.bountyView,
      iconPath: 'assets/images/app/bounty.png',
      activeIconPath: 'assets/images/app/active_bounty.png',
      labelKey: "31017718",
    ),
    NavItem(
      route: RouterPath.actingView,
      iconPath: 'assets/images/app/invite.png',
      activeIconPath: 'assets/images/app/active_invite.png',
      labelKey: "31017719",
    ),
    NavItem(
      route: RouterPath.activityView,
      iconPath: 'assets/images/app/award.png',
      activeIconPath: 'assets/images/app/active_award.png',
      labelKey: "31017720",
    ),
    NavItem(
      route: RouterPath.userView,
      iconPath: 'assets/images/app/mine.png',
      activeIconPath: 'assets/images/app/active_mine.png',
      labelKey: "31017721",
    ),
  ];
}

class NavItem {
  final String route;
  final String iconPath;
  final String activeIconPath;
  final String labelKey;

  const NavItem({
    required this.route,
    required this.iconPath,
    required this.activeIconPath,
    required this.labelKey,
  });
}

class MainView extends StatefulWidget {
  final Widget child;

  const MainView({super.key, required this.child});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    I10nUtil().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed,
        items: _buildNavItems(context),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems(BuildContext context) {
    return NavConfig.items.map((item) {
      return BottomNavigationBarItem(
        icon: _buildNavIcon(item.iconPath),
        activeIcon: _buildNavIcon(item.activeIconPath),
        label: I10nUtil.tr(item.labelKey),
      );
    }).toList();
  }

  Widget _buildNavIcon(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      width: 50.w,
      height: 50.w,
      errorBuilder: (_, __, ___) => const Icon(Icons.error),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return NavConfig.items.indexWhere((item) => item.route == location);
  }

  void _onTap(BuildContext context, int index) {
    if (index >= 0 && index < NavConfig.items.length) {
      context.go(NavConfig.items[index].route);
    }
  }
}
