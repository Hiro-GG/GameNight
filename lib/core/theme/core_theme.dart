import 'package:flutter/material.dart';

class AppColors {
  // Azul noche como primario y ámbar cálido como acento: "noche de juegos".
  static const Color primario = Color(0xFF2D2A6E);
  static const Color primarioClaro = Color(0xFFECEBFA);
  static const Color acento = Color(0xFFFFB547);
  static const Color acentoClaro = Color(0xFFFFF3DD);
  static const Color favorito = Color(0xFFFF5A5F);
  static const Color pendiente = Color(0xFF6C63FF);
  static const Color textoPrincipal = Color(0xFF1D1D2B);
  static const Color textoSecundario = Color(0xFF6E6E80);
  static const Color fondo = Color(0xFFF7F7FB);
  static const Color superficie = Colors.white;
  static const Color linea = Color(0x14000000);

  // Un color por nivel de dificultad para reconocerla de un vistazo.
  static const Color facil = Color(0xFF2EAD6B);
  static const Color media = Color(0xFFF2A33A);
  static const Color dificil = Color(0xFFE5484D);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class AppRadius {
  static const double sm = 10.0;
  static const double md = 16.0;
  static const double lg = 24.0;
}

ThemeData buildGameNightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primario,
    primary: AppColors.primario,
    secondary: AppColors.acento,
    surface: AppColors.superficie,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.fondo,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.fondo,
      foregroundColor: AppColors.textoPrincipal,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: AppColors.textoPrincipal,
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        color: AppColors.textoPrincipal,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.4,
        color: AppColors.textoPrincipal,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textoPrincipal,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        height: 1.5,
        color: AppColors.textoSecundario,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textoSecundario),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm + 4),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primario,
        minimumSize: const Size(0, 52),
        side: const BorderSide(color: AppColors.primario, width: 1.5),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm + 4),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.superficie,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm + 4),
        borderSide: const BorderSide(color: AppColors.linea),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm + 4),
        borderSide: const BorderSide(color: AppColors.linea),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm + 4),
        borderSide: const BorderSide(color: AppColors.primario, width: 1.5),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.superficie,
      selectedColor: AppColors.primario,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textoPrincipal,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      side: const BorderSide(color: AppColors.linea),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.superficie,
      indicatorColor: AppColors.primarioClaro,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.primario
              : AppColors.textoSecundario,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primario,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
      ),
    ),
  );
}
