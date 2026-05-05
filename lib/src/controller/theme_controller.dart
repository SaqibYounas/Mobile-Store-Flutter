import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the active light/dark theme. Persists the choice via
/// `SharedPreferences` so the app remembers the mode across launches.
///
/// Usage:
/// ```dart
/// final theme = Get.find<ThemeController>();
/// theme.toggle();        // flip light <-> dark
/// theme.setMode(ThemeMode.dark);
/// ```
class ThemeController extends GetxController {
  static const _prefsKey = 'theme_mode';

  final Rx<ThemeMode> mode = ThemeMode.system.obs;

  bool get isDark {
    if (mode.value == ThemeMode.dark) return true;
    if (mode.value == ThemeMode.light) return false;
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  @override
  void onInit() {
    super.onInit();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    mode.value = _fromWire(stored);
  }

  /// Flip light <-> dark, ignoring `system`. If currently `system`, jumps
  /// to the opposite of whatever the OS currently shows.
  Future<void> toggle() async {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    await setMode(next);
  }

  Future<void> setMode(ThemeMode next) async {
    mode.value = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _toWire(next));
    Get.changeThemeMode(next);
  }

  static String _toWire(ThemeMode mode) => switch (mode) {
        ThemeMode.dark => 'dark',
        ThemeMode.light => 'light',
        ThemeMode.system => 'system',
      };

  static ThemeMode _fromWire(String? wire) => switch (wire) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };
}
