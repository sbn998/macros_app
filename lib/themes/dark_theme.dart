import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO: Fix icon colors.
// Implement button styling.

enum DarkThemeColors {
  textColor(Colors.white),
  backgroundColor(Color.fromARGB(255, 32, 36, 35)),
  accentColor(Color.fromARGB(255, 89, 240, 220));

  final Color color;

  const DarkThemeColors(this.color);
}

final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: DarkThemeColors.backgroundColor.color,
  surface: DarkThemeColors.backgroundColor.color,
);

BottomNavigationBarThemeData _bottomNavigationBarThemeData() {
  return BottomNavigationBarThemeData(
    backgroundColor: darkColorScheme.surface,
    unselectedIconTheme: IconThemeData(
      color: DarkThemeColors.textColor.color,
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
  );
}

BottomSheetThemeData _bottomSheetThemeData() {
  return BottomSheetThemeData(
    backgroundColor: DarkThemeColors.backgroundColor.color,
    modalBackgroundColor: DarkThemeColors.backgroundColor.color,
  );
}

CardTheme _cardTheme() {
  return CardTheme(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
      left: Radius.elliptical(12, 12),
      right: Radius.elliptical(12, 12),
    )),
    color: darkColorScheme.onSurface,
    shadowColor: DarkThemeColors.accentColor.color,
    elevation: 3,
    margin: const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 12,
    ),
  );
}

TextStyle _defaultTextStyle() {
  return GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    color: DarkThemeColors.textColor.color,
  );
}

final ThemeData darkTheme = ThemeData().copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkColorScheme.surface,
  dialogBackgroundColor: darkColorScheme.surface,
  bottomNavigationBarTheme: _bottomNavigationBarThemeData(),
  bottomSheetTheme: _bottomSheetThemeData(),
  colorScheme: darkColorScheme,
  cardTheme: _cardTheme(),
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    bodySmall: _defaultTextStyle(),
    bodyMedium: _defaultTextStyle(),
    bodyLarge: _defaultTextStyle(),
    titleSmall: _defaultTextStyle(),
    titleMedium: _defaultTextStyle(),
    titleLarge: _defaultTextStyle(),
  ),
);
