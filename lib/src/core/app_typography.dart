import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Centralised text styles. Most do **not** specify a color so they
/// inherit from the surrounding theme's `DefaultTextStyle` — this lets
/// the same style render correctly under both light and dark themes.
///
/// The exceptions are styles tied to brand identity (prices, captions
/// on colored backgrounds) which keep their explicit color so they stay
/// visually consistent regardless of theme.
class AppText {
  const AppText._();

  // ---- Display / heading ---------------------------------------------------
  static const displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
  );

  static const headingLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static const titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  // ---- Body ----------------------------------------------------------------
  static const bodyMedium = TextStyle(fontSize: 14);
  static const bodySmall = TextStyle(fontSize: 12);

  static const caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  // ---- Price (brand-tinted, theme-independent) ----------------------------
  static const priceLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColor.brandIndigo,
  );

  static const priceMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w900,
    color: AppColor.brandIndigoDeep,
  );

  static const priceStrike = TextStyle(
    fontSize: 12,
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  );
}
