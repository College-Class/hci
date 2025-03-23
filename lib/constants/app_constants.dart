import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF3A4875);
  static const Color primaryDark = Color(0xFF333333);
  static const Color primaryGrey = Color(0xFFF5F5F5);
  static const Color primaryWhite = Color(0xFFFFFFFF);

  // Secondary colors
  static const Color accentOrange = Color(0xFFFF7E55);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentBlue = Color(0xFFCDE1FF);
  static const Color textGrey = Color(0xFF666666);
  static const Color borderColor = Color(0xFFEEEEEE);

  // Additional colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x1A000000);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53935);
  static const Color warningYellow = Color(0xFFFFC107);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.primaryDark,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryWhite,
  );
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;

  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;

  static const double elevation = 2.0;
  static const double cardElevation = 4.0;
}

class AppAnimations {
  static const Duration shortDuration = Duration(milliseconds: 150);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);
}
