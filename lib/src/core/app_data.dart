import 'package:flutter/material.dart';

/// Lightweight static data shared across screens. Most catalog data now
/// comes from Supabase; only generic placeholders remain here.
class AppData {
  const AppData._();

  /// Default value for `Product.about` when none is provided.
  static const String dummyText =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry.';

  /// Soft pastel background colours used by promo / recommendation cards.
  static List<Color> randomColors = const [
    Color(0xFFFCE4EC),
    Color(0xFFF3E5F5),
    Color(0xFFEDE7F6),
    Color(0xFFE3F2FD),
    Color(0xFFE0F2F1),
    Color(0xFFF1F8E9),
    Color(0xFFFFF8E1),
    Color(0xFFECEFF1),
  ];
}
