import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

class BountyController extends GetxController {
  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 请求数据
  Future<void> loadData() async {
    refreshData();
  }

  Future<void> refreshData() async {
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 2));

    // 更新数据后手动结束刷新
    easyRefreshController.finishRefresh();
  }

  Future<void> loadMoreData() async {
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 2));

    // 更新数据后手动结束加载
    easyRefreshController.finishLoad();
  }

  @override
  void dispose() {
    easyRefreshController.dispose();
    super.dispose();
  }

}
