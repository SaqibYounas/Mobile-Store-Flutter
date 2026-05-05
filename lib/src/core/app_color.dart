import 'package:flutter/material.dart';

/// Single source of truth for colors used across the app.
///
/// Surface / text constants are kept as light-mode defaults. Widgets that
/// need to react to theme should pull from `Theme.of(context).colorScheme`
/// instead of these constants. Brand colors (indigo, purple, gradients)
/// are intentionally fixed across light + dark mode for brand identity.
class AppColor {
  const AppColor._();

  // ---- Brand (theme-independent) ------------------------------------------
  static const brandIndigo = Color(0xFF6366F1);
  static const brandIndigoDeep = Color(0xFF4F46E5);
  static const brandPurple = Color(0xFFA855F7);
  static const paymentBlue = Color(0xFF635BFF);

  static const primary = Color(0xFFFF6B2C);
  static const secondary = Color(0xFFFFB38A);
  static const accent = Color(0xFFE65100);

  // ---- Light surfaces ------------------------------------------------------
  static const background = Color(0xFFF8F9FD);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceGrey = Color(0xFFF3F4F6);

  // ---- Dark surfaces ------------------------------------------------------
  static const darkBackground = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkSurfaceElevated = Color(0xFF273449);
  static const darkSurfaceGrey = Color(0xFF334155);

  // ---- Text (light) -------------------------------------------------------
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF4B5563);
  static const textTertiary = Color(0xFF6E6E6E);
  static const textHint = Color(0xFFB0B0B0);

  // ---- Text (dark) --------------------------------------------------------
  static const darkTextPrimary = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFFCBD5E1);
  static const darkTextTertiary = Color(0xFF94A3B8);
  static const darkTextHint = Color(0xFF64748B);

  // ---- Status (theme-independent) -----------------------------------------
  static const success = Color(0xFF2ECC71);
  static const error = Color(0xFFE74C3C);
  static const warning = Color(0xFFF1C40F);

  // ---- Misc ----------------------------------------------------------------
  static const shadow = Color(0x14000000);
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEAEAEA);
  static const grey300 = Color(0xFFD6D6D6);

  // ---- Common gradients ----------------------------------------------------
  static const gradientPrimary = LinearGradient(
    colors: [brandIndigo, brandIndigoDeep],
  );

  static const gradientPromo = LinearGradient(
    colors: [brandIndigo, brandPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientAuth = LinearGradient(
    colors: [Color(0xFF4338CA), Color(0xFF7C3AED), Color(0xFFDB2777)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
