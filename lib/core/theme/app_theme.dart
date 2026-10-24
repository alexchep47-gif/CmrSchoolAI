import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF123B70);
  static const orange = Color(0xFFFFA62B);
  static const mint = Color(0xFF2BBF9B);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: navy, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: navy, brightness: Brightness.dark),
      );
}
