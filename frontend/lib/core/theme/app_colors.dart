import 'package:flutter/material.dart';

/// Central colour palette for the Medic Abroad app.
///
/// Colours are taken directly from the Sree Consultancy brand logo:
/// a deep royal navy (primary) paired with an antique gold accent on white.
/// Navy signals trust and professionalism; gold signals premium guidance.
class AppColors {
  AppColors._();

  // Brand — navy
  static const Color primary = Color(0xFF1F2A6E); // logo navy
  static const Color primaryDark = Color(0xFF16205A);
  static const Color primaryLight = Color(0xFFEAECF7); // navy tint (chips/badges)

  // Brand — gold
  static const Color accent = Color(0xFFC2A24E); // logo antique gold
  static const Color accentDark = Color(0xFF9C7F34);
  static const Color accentLight = Color(0xFFF6EFDD); // gold tint

  // Surfaces
  static const Color background = Color(0xFFF6F7FB); // cool white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEFF1F8);

  // Text
  static const Color textPrimary = Color(0xFF1A2036); // navy-charcoal
  static const Color textSecondary = Color(0xFF565E7A);
  static const Color textMuted = Color(0xFF9AA1B8);

  // Lines
  static const Color border = Color(0xFFE2E5F0);

  // States
  static const Color success = Color(0xFF2E7D5B);
  static const Color error = Color(0xFFC0392B);
  static const Color closed = Color(0xFFC0392B);
  static const Color disabled = Color(0xFFCBD1E0);
}
