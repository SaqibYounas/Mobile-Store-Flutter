import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/admin_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_stat_tile.dart';

/// Reactive row of three [AdminStatTile]s: total products, active products,
/// and total orders. Reads counts directly from [AdminController].
class AdminStatsRow extends StatelessWidget {
  const AdminStatsRow({super.key, required this.controller});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Obx(() {
        final total = controller.products.length;
        final active = controller.products.where((p) => p.isActive).length;
        final orders = controller.orders.length;
        return Row(
          children: [
            Expanded(
              child: AdminStatTile(
                label: 'Products',
                value: '$total',
                icon: Icons.inventory_2_rounded,
                color: AppColor.brandIndigo,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AdminStatTile(
                label: 'Active',
                value: '$active',
                icon: Icons.verified_rounded,
                color: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AdminStatTile(
                label: 'Orders',
                value: '$orders',
                icon: Icons.receipt_long_rounded,
                color: AppColor.brandPurple,
              ),
            ),
          ],
        );
      }),
    );
  }
}
