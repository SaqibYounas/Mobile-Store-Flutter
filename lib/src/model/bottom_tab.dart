import 'package:flutter/widgets.dart';

/// Static description of a bottom navigation tab — its label and the
/// inactive / active icon variants. Held by [HomeScreen]'s tab list and
/// rendered by `ModernBottomBar`.
class BottomTab {
  const BottomTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
