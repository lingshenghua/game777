import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game777/common/export.dart';
import 'package:game777/common/widgets/custom_button.dart';
import 'package:game777/core/export.dart';
import 'package:game777/l10n/export.dart';
import 'package:game777/modules/game/bindings/game_binding.dart';
import 'package:game777/modules/game/controllers/game_controller.dart';
import 'package:get/get.dart';

class GameView extends BasePage<GameController, GameBinding> {
  GameView({super.key})
      : super(
          bindingFactory: () => GameBinding(),
          autoDisposeController: false,
        );

  @override
  Widget buildPage(BuildContext context, GameController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('GameView')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100.h,
              width: 100.w,
              color: ColorUtil.success,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => AppLocalizations.changeLocale(const Locale('id')),
              child: Container(
                height: 80.h,
                width: 240.w,
                alignment: Alignment.center,
                color: ColorUtil.primary,
                child: const Text('切换印尼语'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => AppLocalizations.changeLocale(const Locale('zh')),
              child: Container(
                height: 80.h,
                width: 240.w,
                alignment: Alignment.center,
                color: ColorUtil.success,
                child: const Text('切换中文'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                controller.openBottomSheet(context);
              },
              child: Container(
                height: 80.h,
                width: 240.w,
                alignment: Alignment.center,
                color: ColorUtil.success,
                child: const Text('showSelectBottomSheet'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => Get.find<SystemController>().toggleTheme(),
              child: Container(
                height: 80.h,
                width: 240.w,
                alignment: Alignment.center,
                color: ColorUtil.success,
                child: const Text('切换'),
              ),
            ),
            SmartImage.circle(
              size: 100.w,
              url:
                  'https://pics1.baidu.com/feed/a5c27d1ed21b0ef4d0d3794da512ecd780cb3eca.jpeg@f_auto?token=b67c2521dd19c9474ce7c763a0f151d5',
            ),
            SmartImage.circle(
              size: 100.w,
              url:
                  'https://pics1.baidu.com/feed/a5c27d1ed21b0ef4d0d3794da512ecd780cb3eca.jpeg@f_auto?token=b67c2521dd19c9474ce7c763a0f151d5',
            ),
            SmartImage.circle(
              size: 100.w,
              url:
                  'https://pics1.baidu.com/feed/a5c27d1ed21b0ef4d0d3794da512ecd780cb3eca.jpeg@f_auto?token=b67c2521dd19c9474ce7c763a0f151d5',
            ),
            const SmartText('Hello World', type: TextType.h1),
            SmartText(
              '1001',
              useLocalization: true,
              type: TextType.button,
              color: Colors.red,
              // 覆盖默认颜色
              fontSize: 20, // 覆盖默认字号
            ),
            SmartText(
              '1002',
              useLocalization: true,
              translationModule: LanguageEnum.common,
              type: TextType.button,
              color: Colors.red,
              // 覆盖默认颜色
              fontSize: 20, // 覆盖默认字号
            ),
            SmartText(
              '哈哈哈哈哈哈哈',
              style: const TextStyle(
                shadows: [Shadow(color: Colors.black, blurRadius: 2)],
              ),
              textAlign: TextAlign.center,
            ),
            CustomButton(
              text: '提交',
              loading: false,          // 加载状态
              disabled: false,        // 禁用状态
              onPressed: () {},       // 点击回调
            )
          ],
        ),
      ),
    );
  }

  @override
  void onControllerReady(GameController controller) {

  }
}
