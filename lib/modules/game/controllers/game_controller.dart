import 'package:flutter/material.dart';
import 'package:game777/common/widgets/select_bottom_sheet_view.dart';
import 'package:game777/core/services/user_center/response/device_response.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  /// 请求数据
  Future<void> openBottomSheet(BuildContext context) async {
    showSelectBottomSheet<DeviceResponse>(
      context: context,
      items: [
        DeviceResponse(deviceId: "1001", createTime: "哈哈哈1"),
        DeviceResponse(deviceId: "1002", createTime: "哈哈哈2"),
        DeviceResponse(deviceId: "1003", createTime: "哈哈哈3"),
        DeviceResponse(deviceId: "1004", createTime: "哈哈哈4"),
        DeviceResponse(deviceId: "1005", createTime: "哈哈哈5"),
      ],
      itemTitleKey: 'createTime',
      itemValueKey: 'deviceId',
      initialValues: ["1001"],
      isMultiple: true,
      onConfirm: (selected) {
        Get.log('$selected');
      },
    );
  }
}
