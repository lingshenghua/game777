import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showSelectBottomSheet<T>({
  required BuildContext context,
  required List<T> items,
  required String itemTitleKey,
  required String itemValueKey,
  List<dynamic> initialValues = const [],
  bool isMultiple = false,
  Function(List<dynamic>)? onConfirm,
}) {
  final controller = Get.put(SelectBottomSheetController<T>());
  controller.initConfig(
    items: items,
    itemTitleKey: itemTitleKey,
    itemValueKey: itemValueKey,
    initialValues: initialValues,
    isMultiple: isMultiple,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => GetBuilder<SelectBottomSheetController<T>>(
      init: controller,
      builder: (_) => _BottomSheetContent<T>(onConfirm: onConfirm),
    ),
  );
}

class _BottomSheetContent<T> extends StatelessWidget {
  final Function(List<dynamic>)? onConfirm;

  const _BottomSheetContent({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectBottomSheetController<T>>();

    return Container(
      height: 600.h,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(controller, context),
          const SizedBox(height: 12),
          Expanded(child: _buildList(controller)),
        ],
      ),
    );
  }

  Widget _buildHeader(SelectBottomSheetController<T> controller, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(controller.isMultiple ? '多选模式' : '单选模式'),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(controller.selectedValues.toList());
            }
            Navigator.pop(context, controller.selectedValues.toList()); // 改为原生导航关闭
          },
          child: const Text('确认'),
        ),
      ],
    );
  }

  Widget _buildList(SelectBottomSheetController<T> controller) {
    return ListView.separated(
      itemCount: controller.items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (ctx, index) {
        final item = controller.items[index];
        final value = controller.getItemValue(item);

        return Obx(() => _buildListItem(
              title: controller.getItemTitle(item),
              isSelected: controller.selectedValues.contains(value),
              onTap: () => controller.toggleSelect(value),
              isMultiple: controller.isMultiple,
            ));
      },
    );
  }

  Widget _buildListItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isMultiple,
  }) {
    return ListTile(
      title: Text(title),
      trailing: isMultiple
          ? Checkbox(value: isSelected, onChanged: (_) => onTap())
          : Radio<bool>(value: true, groupValue: isSelected, onChanged: (_) => onTap()),
      onTap: onTap,
    );
  }
}

class SelectBottomSheetController<T> extends GetxController {
  /// 原始数据列表
  late List<T> items;

  /// 配置字段
  late String itemTitleKey;
  late String itemValueKey;
  late bool isMultiple;

  /// 选中值集合
  RxSet<dynamic> selectedValues = <dynamic>{}.obs;

  /// 初始化配置
  void initConfig({
    required List<T> items,
    required String itemTitleKey,
    required String itemValueKey,
    required List<dynamic> initialValues,
    bool isMultiple = false,
  }) {
    /// 清空旧数据
    this.items = [];
    selectedValues.clear();

    this.items = items;
    assert(_validateFieldExists(items.first, itemTitleKey), 'itemTitleKey "$itemTitleKey" 不存在于模型字段中');
    assert(_validateFieldExists(items.first, itemValueKey), 'itemValueKey "$itemValueKey" 不存在于模型字段中');
    this.itemTitleKey = itemTitleKey;
    this.itemValueKey = itemValueKey;
    this.isMultiple = isMultiple;
    selectedValues.addAll(initialValues.where((v) => v != null));

    /// 强制刷新
    update();
  }

  bool _validateFieldExists(T item, String key) {
    try {
      final json = (item as dynamic).toJson() as Map<String, dynamic>;
      return json.containsKey(key);
    } catch (_) {
      return false;
    }
  }

  /// 处理选项点击
  void toggleSelect(dynamic value) {
    if (isMultiple) {
      _toggleMultiSelect(value);
    } else {
      _toggleSingleSelect(value);
    }
  }

  void _toggleMultiSelect(dynamic value) {
    if (selectedValues.contains(value)) {
      selectedValues.remove(value);
    } else {
      selectedValues.add(value);
    }
  }

  void _toggleSingleSelect(dynamic value) {
    selectedValues.clear();
    selectedValues.add(value);
  }

  /// 获取显示文本
  String getItemTitle(T item) {
    try {
      final json = (item as dynamic).toJson() as Map<String, dynamic>;
      return json[itemTitleKey]?.toString() ?? '';
    } catch (e) {
      return '';
    }
  }

  /// 获取实际值
  dynamic getItemValue(T item) {
    try {
      final json = (item as dynamic).toJson() as Map<String, dynamic>;
      return json[itemValueKey];
    } catch (e) {
      return null;
    }
  }
}
