import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LightThemeColors {
  textColor(Color.fromARGB(255, 32, 36, 35)),
  backgroundColor(Color.fromARGB(255, 213, 230, 232));

  final Color color;

  const LightThemeColors(this.color);
}

final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: LightThemeColors.backgroundColor.color,
  surface: LightThemeColors.backgroundColor.color,
);

final ThemeData lightTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: lightColorScheme.surface,
  colorScheme: lightColorScheme,
  cardTheme: CardTheme(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
      left: Radius.elliptical(12, 12),
      right: Radius.elliptical(12, 12),
    )),
    color: lightColorScheme.onSurface,
    shadowColor: const Color.fromARGB(255, 89, 240, 220),
    elevation: 3,
    margin: const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 12,
    ),
  ),
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    bodyMedium: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textColor.color,
    ),
    bodyLarge: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textColor.color,
    ),
    titleSmall: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textColor.color,
    ),
    titleMedium: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textColor.color,
    ),
    titleLarge: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textColor.color,
    ),
  ),
);
