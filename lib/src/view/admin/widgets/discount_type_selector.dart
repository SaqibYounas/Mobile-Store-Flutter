import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/model/product.dart';

/// Wrap of choice chips for picking a [DiscountType]. Used inside the
/// admin product form's pricing section.
class DiscountTypeSelector extends StatelessWidget {
  const DiscountTypeSelector({
    super.key,
    required this.type,
    required this.onChanged,
  });

  final DiscountType type;
  final ValueChanged<DiscountType> onChanged;

  static String _label(DiscountType t) => switch (t) {
        DiscountType.none => 'No discount',
        DiscountType.percentage => 'Percentage',
        DiscountType.fixed => 'Fixed amount',
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: DiscountType.values.map((t) {
        final selected = t == type;
        return ChoiceChip(
          label: Text(_label(t)),
          selected: selected,
          onSelected: (_) => onChanged(t),
          backgroundColor: Theme.of(context).cardColor,
          selectedColor: AppColor.brandIndigo,
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColor.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: selected ? AppColor.brandIndigo : AppColor.grey200,
            ),
          ),
        );
      }).toList(),
    );
  }
}
