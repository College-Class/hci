import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'providers/home_provider.dart';
import 'models/room_model.dart';
import 'models/device_model.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/room_detail_screen.dart';
import 'screens/device_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HomeProvider())],
      child: MaterialApp(
        title: 'Smart Home',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryBlue,
          scaffoldBackgroundColor: AppColors.primaryGrey,
          fontFamily: GoogleFonts.inter().fontFamily,

          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
            primary: AppColors.primaryBlue,
            secondary: AppColors.accentOrange,
            surface: AppColors.cardBackground,
            background: AppColors.primaryGrey,
            error: AppColors.errorRed,
          ),
          useMaterial3: true,

          // Card theme
          cardTheme: CardTheme(
            color: AppColors.cardBackground,
            elevation: AppSizes.cardElevation,
            shadowColor: AppColors.shadowColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
          ),

          // AppBar theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: AppColors.primaryBlue),
          ),

          // Button themes
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: AppSizes.elevation,
              shadowColor: AppColors.shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: AppTextStyles.button,
              minimumSize: const Size(double.infinity, 56),
            ),
          ),

          // Text button theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: AppColors.errorRed),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintStyle: AppTextStyles.bodySmall,
            errorStyle: TextStyle(color: AppColors.errorRed),
          ),

          // Switch theme
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.primaryBlue;
              }
              return Colors.grey;
            }),
            trackColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.primaryBlue.withOpacity(0.5);
              }
              return Colors.grey.withOpacity(0.3);
            }),
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),

          // Checkbox theme
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.primaryBlue;
              }
              return Colors.transparent;
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Slider theme
          sliderTheme: SliderThemeData(
            activeTrackColor: AppColors.primaryBlue,
            inactiveTrackColor: AppColors.primaryBlue.withOpacity(0.2),
            thumbColor: AppColors.primaryBlue,
            overlayColor: AppColors.primaryBlue.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),

          // Tab bar theme
          tabBarTheme: TabBarTheme(
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textGrey,
            indicatorColor: AppColors.primaryBlue,
            dividerColor: Colors.transparent,
          ),
        ),
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          // Handle dynamic routing
          if (settings.name == '/room_detail') {
            final Room room = settings.arguments as Room;
            return MaterialPageRoute(
              builder: (context) => RoomDetailScreen(room: room),
            );
          } else if (settings.name == '/device_detail') {
            final Device device = settings.arguments as Device;
            return MaterialPageRoute(
              builder: (context) => DeviceDetailScreen(device: device),
            );
          }

          // Default routes
          return null;
        },
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
