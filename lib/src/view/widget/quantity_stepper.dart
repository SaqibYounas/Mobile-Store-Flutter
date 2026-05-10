import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Compact -/+ quantity stepper with the current quantity in the middle.
/// Reusable across cart, product detail, admin stock-adjust flows.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    this.maxQuantity = 9999,
    this.minQuantity = 1,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final int maxQuantity;
  final int minQuantity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAtMax = quantity >= maxQuantity;
    final isAtMin = quantity <= minQuantity;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceGrey : AppColor.surfaceGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperBtn(
            icon: Icons.remove,
            onTap: isAtMin ? null : onDecrease,
            isDisabled: isAtMin,
          ),
          SizedBox(
            width: 24,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _StepperBtn(
            icon: Icons.add,
            onTap: isAtMax ? null : onIncrease,
            isDisabled: isAtMax,
          ),
        ],
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  const _StepperBtn({
    required this.icon,
    required this.onTap,
    this.isDisabled = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        size: 18,
        color: isDisabled
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
            : Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: isDisabled ? null : onTap,
    );
  }
}
