import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Horizontal row of pill-shaped category buttons. The first entry ("All")
/// is always present; the rest come from the backend.
///
/// Pass the currently selected category as [selected] (empty string == All)
/// and an [onSelected] callback that receives the chosen category.
class CategoryButtons extends StatelessWidget {
  const CategoryButtons({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = ['', ...categories];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final value = items[i];
          final label = value.isEmpty ? 'All' : value;
          final isSelected = value == selected;
          return _CategoryPill(
            label: label,
            icon: _iconFor(value),
            isSelected: isSelected,
            onTap: () => onSelected(value),
          );
        },
      ),
    );
  }

  static IconData _iconFor(String category) {
    final c = category.toLowerCase();
    if (c.isEmpty) return Icons.apps_rounded;
    if (c.contains('mobile') || c.contains('phone')) {
      return Icons.smartphone_rounded;
    }
    if (c.contains('tablet')) return Icons.tablet_mac_rounded;
    if (c.contains('watch')) return Icons.watch_rounded;
    if (c.contains('headphone') || c.contains('audio')) {
      return Icons.headphones_rounded;
    }
    if (c.contains('tv') || c.contains('television')) {
      return Icons.tv_rounded;
    }
    if (c.contains('laptop') || c.contains('computer')) {
      return Icons.laptop_mac_rounded;
    }
    if (c.contains('camera')) return Icons.camera_alt_rounded;
    if (c.contains('accessor')) return Icons.cable_rounded;
    return Icons.category_rounded;
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColor.gradientPrimary : null,
            color: isSelected ? null : theme.cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? AppColor.darkSurfaceGrey : AppColor.grey200),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color:
                          AppColor.brandIndigoDeep.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColor.brandIndigo,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
