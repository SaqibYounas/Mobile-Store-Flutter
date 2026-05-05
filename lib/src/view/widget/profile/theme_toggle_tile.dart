import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/theme_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Profile-screen row that shows the active theme mode and lets the
/// user flip between light and dark via a switch on the right.
class ThemeToggleTile extends StatelessWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeCtrl.isDark;
      final tint = AppColor.brandIndigo;
      return ListTile(
        onTap: themeCtrl.toggle,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: tint,
          ),
        ),
        title: Text(
          'Appearance',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          isDark ? 'Dark mode' : 'Light mode',
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        trailing: Switch.adaptive(
          value: isDark,
          onChanged: (_) => themeCtrl.toggle(),
          activeColor: AppColor.brandIndigo,
        ),
      );
    });
  }
}
