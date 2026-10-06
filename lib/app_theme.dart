import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const ink = Color(0xFF08324A);
  static const inkSoft = Color(0xFF3E6478);
  static const mist = Color(0xFFE7F6FD);
  static const ocean = Color(0xFF0C74C4);
  static const deep = Color(0xFF0A568F);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFB7E9FB), Color(0xFF63C4EF), Color(0xFF1E86C6)],
  );

  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1EC8E8), Color(0xFF0B78D1)],
  );

  static const barGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF8FDCFA), Color(0xFF3AA6DE)],
  );

  static const cardShadow = [
    BoxShadow(color: Color(0x33004166), blurRadius: 18, offset: Offset(0, 10)),
  ];

  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(seedColor: ocean, primary: ocean),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      iconTheme: const IconThemeData(color: ocean),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        showDragHandle: true,
        dragHandleColor: Color(0xFFB7D4E4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      datePickerTheme: const DatePickerThemeData(backgroundColor: Colors.white),
      timePickerTheme: const TimePickerThemeData(backgroundColor: Colors.white),
    );
  }
}
