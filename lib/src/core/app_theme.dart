import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Centralised light + dark themes. Buttons, surfaces, inputs and chip
/// styling come from these so individual widgets only need to call
/// `Theme.of(context).colorScheme.X` to react to mode changes.
class AppTheme {
  const AppTheme._();

  static final ThemeData lightAppTheme = _build(
    brightness: Brightness.light,
    background: AppColor.background,
    surface: AppColor.surface,
    surfaceGrey: AppColor.surfaceGrey,
    onSurface: AppColor.textPrimary,
    onSurfaceVariant: AppColor.textTertiary,
    hint: AppColor.textHint,
    inputFill: AppColor.surfaceGrey,
    cardColor: AppColor.surface,
    dividerColor: AppColor.grey200,
  );

  static final ThemeData darkAppTheme = _build(
    brightness: Brightness.dark,
    background: AppColor.darkBackground,
    surface: AppColor.darkSurface,
    surfaceGrey: AppColor.darkSurfaceGrey,
    onSurface: AppColor.darkTextPrimary,
    onSurfaceVariant: AppColor.darkTextTertiary,
    hint: AppColor.darkTextHint,
    inputFill: AppColor.darkSurfaceElevated,
    cardColor: AppColor.darkSurface,
    dividerColor: AppColor.darkSurfaceGrey,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceGrey,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color hint,
    required Color inputFill,
    required Color cardColor,
    required Color dividerColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColor.brandIndigo,
      brightness: brightness,
      primary: AppColor.brandIndigo,
      secondary: AppColor.brandPurple,
      surface: surface,
      onSurface: onSurface,
      error: AppColor.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      canvasColor: surface,
      cardColor: cardColor,
      dialogTheme: DialogThemeData(backgroundColor: surface),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surface),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.brandIndigo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColor.brandIndigoDeep),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.brandIndigo,
          side: const BorderSide(color: AppColor.brandIndigo, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColor.brandIndigo, width: 1.4),
        ),
        labelStyle: TextStyle(color: onSurfaceVariant),
        hintStyle: TextStyle(color: hint),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceGrey,
        selectedColor: AppColor.brandIndigo,
        secondarySelectedColor: AppColor.brandIndigo,
        labelStyle: TextStyle(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
      iconTheme: IconThemeData(color: onSurface),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColor.brandIndigo,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        bodyLarge: TextStyle(fontSize: 15, color: onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: onSurfaceVariant),
        bodySmall: TextStyle(fontSize: 12, color: onSurfaceVariant),
      ),
    );
  }
}
