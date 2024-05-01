import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData initialTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        background: Colors.grey.shade900,
        primary: Colors.grey.shade800,
        secondary: Colors.grey.shade700,
        onBackground: Colors.grey.shade600,
        onPrimary: Colors.grey.shade500,
        onSecondary: Colors.grey.shade400,
        surface: Colors.grey.shade300,
        onSurface: Colors.grey.shade200,
        onPrimaryContainer: darken(Colors.grey.shade900),
      ),
    );
  }

  static ThemeData newTheme(MaterialColor primarySwatchColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        background: primarySwatchColor.shade900,
        primary: primarySwatchColor.shade800,
        secondary: primarySwatchColor.shade700,
        onBackground: primarySwatchColor.shade600,
        onPrimary: primarySwatchColor.shade500,
        onSecondary: primarySwatchColor.shade400,
        surface: primarySwatchColor.shade300,
        onSurface: primarySwatchColor.shade200,
        onPrimaryContainer: darken(primarySwatchColor.shade900),
      ),
    );
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
