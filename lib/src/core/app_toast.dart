import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Right-aligned, top-positioned toast notifications. Used app-wide for
/// cart, admin and auth feedback. Auto-dismiss after 4s.
///
/// Implementation note: Get.snackbar's "TOP" position covers the full width.
/// To get a right-side card on phones we constrain the maxWidth and push the
/// margin to the right edge. On wider screens (tablet/desktop) the toast
/// sits in the top-right corner.
class AppToast {
  const AppToast._();

  static const _duration = Duration(seconds: 4);

  static void success(String title, String message) =>
      _show(title, message, _Variant.success);

  static void error(String title, String message) =>
      _show(title, message, _Variant.error);

  static void info(String title, String message) =>
      _show(title, message, _Variant.info);

  static void _show(String title, String message, _Variant variant) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();

    final width = Get.width;
    final isWide = width > 600;
    final cardWidth = isWide ? 360.0 : (width - 32);
    final leftMargin = isWide ? width - cardWidth - 16 : 16.0;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: _duration,
      margin: EdgeInsets.only(top: 16, left: leftMargin, right: 16, bottom: 0),
      maxWidth: cardWidth,
      borderRadius: 14,
      backgroundColor: variant.color,
      colorText: Colors.white,
      icon: Icon(variant.icon, color: Colors.white, size: 24),
      shouldIconPulse: false,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 350),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      boxShadows: const [
        BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 6)),
      ],
    );
  }
}

enum _Variant { success, error, info }

extension on _Variant {
  Color get color => switch (this) {
        _Variant.success => const Color(0xFF16A34A),
        _Variant.error => const Color(0xFFDC2626),
        _Variant.info => AppColor.brandIndigo,
      };

  IconData get icon => switch (this) {
        _Variant.success => Icons.check_circle_rounded,
        _Variant.error => Icons.error_rounded,
        _Variant.info => Icons.info_rounded,
      };
}
