import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 左进右出动画
GoRoute leftInRightOut(String path, Widget Function(BuildContext, GoRouterState) builder) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: builder(context, state),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    },
  );
}
