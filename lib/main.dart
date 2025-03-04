import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game777/initialize/app_initialize.dart';
import 'package:game777/core/export.dart';
import 'package:game777/common/export.dart';
import 'package:game777/l10n/export.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// 开启启动页
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// 应用初始化
  await appInitialize();

  /// 关闭启动页
  FlutterNativeSplash.remove();
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  GameApp({super.key});

  final AppRouter _appRouter = AppRouter();
  final SystemController _systemController = Get.find<SystemController>();
  final GlobalController _globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1624),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp.router(
          routeInformationProvider: _appRouter.router.routeInformationProvider,
          routeInformationParser: _appRouter.router.routeInformationParser,
          routerDelegate: _appRouter.router.routerDelegate,
          backButtonDispatcher: _appRouter.router.backButtonDispatcher,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _systemController.themeMode,
          locale: _systemController.locale,
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("zh"),
            Locale("id"),
          ],

          /// 禁用掉get自带路由
          getPages: [],
          builder: (context, child) {
            return GetBuilder<GlobalController>(
              init: _globalController,
              builder: (ctrl) => child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
