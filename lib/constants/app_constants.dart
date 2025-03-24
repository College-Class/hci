import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF8D99AE);
  static const Color primaryDark = Color(0xFF212121);
  static const Color primaryGrey = Color(0xFFF5F5F5);
  static const Color primaryWhite = Color(0xFFFFFFFF);

  // Secondary colors
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentBlue = Color(0xFFE3F2FD);
  static const Color textGrey = Color(0xFF757575);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Additional colors
  static const Color cardBackground = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color shadowColor = Color(0x1A000000);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53935);
  static const Color warningYellow = Color(0xFFFFB300);

  // Device type colors - Updated for better visibility
  static const Color acColor = Color(0xFF64B5F6); // Brighter blue for AC
  static const Color lightColor = Color(
    0xFFFFD54F,
  ); // Brighter yellow for Lights
  static const Color tvColor = Color(0xFFCE93D8); // Brighter purple for TVs
  static const Color otherColor = Color(
    0xFF81C784,
  ); // Brighter green for Other devices
}

class AppTextStyles {
  // Headings
  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static TextStyle heading3 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  // Body text
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    color: AppColors.textGrey,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textGrey,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textGrey,
  );

  // Button text
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Input text
  static TextStyle input = GoogleFonts.inter(
    fontSize: 16,
    color: AppColors.primaryDark,
  );

  // Label text
  static TextStyle label = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static TextStyle subtitle1 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryDark,
  );

  static TextStyle subtitle2 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryDark,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    color: AppColors.textGrey,
  );
}

class AppSizes {
  // Border radius
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;

  // Elevation
  static const double elevation = 2.0;
  static const double cardElevation = 2.0;
  static const double buttonElevation = 2.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Button sizes
  static const double buttonHeight = 48.0;
  static const double buttonWidth = 200.0;
}

class AppAnimations {
  // Duration
  static const Duration shortDuration = Duration(milliseconds: 150);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);

  // Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
}

class AppImages {
  // Placeholder images
  static const String placeholderDevice =
      'https://images.unsplash.com/photo-1558089687-f282ffcbc0d4?q=80&w=640&auto=format&fit=crop';
  static const String placeholderRoom =
      'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=1000&auto=format&fit=crop';
  static const String placeholderProfile =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=640&auto=format&fit=crop';

  // Device images
  static const String lightBulb =
      'https://images.unsplash.com/photo-1555663823-23e8867f739c?q=80&w=640&auto=format&fit=crop';
  static const String thermostat =
      'https://images.unsplash.com/photo-1652227053304-d1efa6608d97?q=80&w=640&auto=format&fit=crop';
  static const String securityCamera =
      'https://images.unsplash.com/photo-1595939099889-4562aeac3f62?q=80&w=640&auto=format&fit=crop';
  static const String smartLock =
      'https://images.unsplash.com/photo-1590845947676-fa9bea076cc9?q=80&w=640&auto=format&fit=crop';
  static const String smartSpeaker =
      'https://images.unsplash.com/photo-1589492477829-5e65395b66cc?q=80&w=640&auto=format&fit=crop';

  // Room images
  static const String livingRoom =
      'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=1000&auto=format&fit=crop';
  static const String bedroom =
      'https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=1000&auto=format&fit=crop';
  static const String kitchen =
      'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?q=80&w=1000&auto=format&fit=crop';
  static const String bathroom =
      'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000&auto=format&fit=crop';
  static const String office =
      'https://images.unsplash.com/photo-1593476550610-87baa860004a?q=80&w=1000&auto=format&fit=crop';
}

class AppStrings {
  // App info
  static const String appName = 'Smart Home';
  static const String appVersion = '1.0.0';

  // Auth
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';

  // Home
  static const String welcome = 'Welcome';
  static const String home = 'Home';
  static const String rooms = 'Rooms';
  static const String devices = 'Devices';
  static const String scenes = 'Scenes';
  static const String settings = 'Settings';
  static const String profile = 'Profile';

  // Devices
  static const String addDevice = 'Add Device';
  static const String deviceSettings = 'Device Settings';
  static const String deviceStatus = 'Status';
  static const String devicePower = 'Power';
  static const String deviceTemperature = 'Temperature';
  static const String deviceBrightness = 'Brightness';

  // Rooms
  static const String addRoom = 'Add Room';
  static const String roomSettings = 'Room Settings';
  static const String roomDevices = 'Devices';
  static const String roomScenes = 'Scenes';

  // Settings
  static const String appSettings = 'App Settings';
  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String about = 'About';
  static const String help = 'Help & Support';
  static const String privacy = 'Privacy Policy';
  static const String terms = 'Terms of Service';

  // Messages
  static const String success = 'Success';
  static const String error = 'Error';
  static const String warning = 'Warning';
  static const String info = 'Info';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
}
