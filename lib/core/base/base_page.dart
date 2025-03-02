import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 增强版页面基类
/// [C] 控制器类型，必须继承自 GetXController
/// [B] 对应的 Binding 类型
abstract class BasePage<C extends GetxController, B extends Bindings> extends StatefulWidget {
  const BasePage({
    super.key,
    required this.bindingFactory,
    this.autoDisposeController = true,
  });

  final B Function() bindingFactory;
  final bool autoDisposeController;

  /// 抽象方法：必须返回页面内容
  Widget buildPage(BuildContext context, C controller);

  /// 可选的生命周期方法
  void onControllerReady(C controller) {}

  void onPageDispose() {}

  @override
  State<BasePage<C, B>> createState() => _BasePageState<C, B>();
}

class _BasePageState<C extends GetxController, B extends Bindings> extends State<BasePage<C, B>> {
  late final B _binding;
  late final C _controller;

  @override
  void initState() {
    super.initState();
    _initializeBinding();
    _findController();
    _initControllerLifecycle();
  }

  void _initializeBinding() {
    _binding = widget.bindingFactory();
    _binding.dependencies();
  }

  void _findController() {
    try {
      _controller = Get.find<C>();
    } catch (e) {
      throw Exception('''Controller $C not found. Make sure your binding is properly initializing the controller.''');
    }
  }

  void _initControllerLifecycle() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller is LifeCycleMixin) {
        (_controller as LifeCycleMixin).onReady();
      }
      widget.onControllerReady(_controller);
    });
  }

  @override
  void dispose() {
    widget.onPageDispose();
    if (widget.autoDisposeController) {
      _safeDisposeController();
    }
    super.dispose();
  }

  void _safeDisposeController() {
    if (Get.isRegistered<C>()) {
      Get.delete<C>(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<C>(
      builder: (controller) {
        return widget.buildPage(context, controller);
      },
    );
  }
}

/// 生命周期混合接口
mixin LifeCycleMixin on GetxController {
  /// 执行依赖页面渲染完成
  @override
  void onReady();
}
