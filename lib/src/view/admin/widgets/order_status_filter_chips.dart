import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/admin_controller.dart';
import 'package:e_commerce_flutter/src/model/order.dart';

/// Horizontal scroll of `ChoiceChip`s used to filter the admin orders list.
/// First chip is "All" (null filter), the rest map to [OrderStatus] values.
class OrderStatusFilterChips extends StatelessWidget {
  const OrderStatusFilterChips({super.key, required this.controller});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    final filters = <String?>[null, ...OrderStatus.values.map((e) => e.wire)];
    return Container(
      height: 60,
      color: Theme.of(context).cardColor,
      child: Obx(() {
        final selected = controller.orderStatusFilter.value;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final value = filters[i];
            final isSelected = selected == value;
            final label =
                value == null ? 'All' : OrderStatusX.fromWire(value).label;
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => controller.filterOrdersByStatus(value),
            );
          },
        );
      }),
    );
  }
}
