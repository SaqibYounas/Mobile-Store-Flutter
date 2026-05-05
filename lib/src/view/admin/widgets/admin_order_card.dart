import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/model/order.dart';
import 'package:e_commerce_flutter/src/model/order_item.dart';
import 'package:e_commerce_flutter/src/view/widget/app_card.dart';
import 'package:e_commerce_flutter/src/view/widget/status_badge.dart';

/// Card-style summary of one customer order. Shows order id, customer
/// info, line items, total, and a "Change status" popup that calls
/// [onChangeStatus] with the chosen [OrderStatus].
class AdminOrderCard extends StatelessWidget {
  const AdminOrderCard({
    super.key,
    required this.order,
    required this.onChangeStatus,
  });

  final OrderModel order;
  final void Function(OrderStatus) onChangeStatus;

  static final _df = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderHeader(order: order),
          const SizedBox(height: 6),
          Text(
            _df.format(order.createdAt ?? DateTime.now()),
            style: AppText.bodySmall,
          ),
          const Divider(height: 24),
          _OrderCustomerInfo(order: order),
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: 12),
            _OrderLineItems(items: order.items),
            const Divider(height: 20),
          ],
          _OrderTotalRow(total: order.totalAmount),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _ChangeStatusButton(onSelected: onChangeStatus),
          ),
        ],
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Order #${order.id?.substring(0, 8) ?? '---'}',
            style: AppText.titleMedium,
          ),
        ),
        StatusBadge(status: order.status.wire),
      ],
    );
  }
}

class _OrderCustomerInfo extends StatelessWidget {
  const _OrderCustomerInfo({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(Icons.person_outline, order.recipientName),
        _row(Icons.phone_outlined, order.phone),
        _row(Icons.location_on_outlined, order.shippingAddress),
      ],
    );
  }

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColor.textTertiary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppText.bodyMedium)),
        ],
      ),
    );
  }
}

class _OrderLineItems extends StatelessWidget {
  const _OrderLineItems({required this.items});

  final List<OrderItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColor.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map(
          (it) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${it.productName} ×${it.quantity}',
                    style: AppText.bodyMedium,
                  ),
                ),
                Text(
                  'Rs.${it.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderTotalRow extends StatelessWidget {
  const _OrderTotalRow({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Total', style: AppText.titleMedium),
        const Spacer(),
        Text(
          'Rs.${total.toStringAsFixed(2)}',
          style: AppText.priceMedium.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}

class _ChangeStatusButton extends StatelessWidget {
  const _ChangeStatusButton({required this.onSelected});

  final void Function(OrderStatus) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OrderStatus>(
      onSelected: onSelected,
      itemBuilder: (_) => OrderStatus.values
          .map((s) => PopupMenuItem(value: s, child: Text(s.label)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: AppColor.gradientPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              'Change status',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
