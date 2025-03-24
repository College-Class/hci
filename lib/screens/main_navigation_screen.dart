import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/home_provider.dart';
import 'home_screen.dart';
import 'devices_screen.dart';
import 'rooms_screen.dart';
import 'ai_chat_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key, this.initialIndex = 0})
    : super(key: key);

  final int initialIndex;

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  late PageController _pageController;
  Timer? _updateTimer;

  // List of screens for the bottom navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    const RoomsScreen(),
    const DevicesScreen(),
    const AIChatScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // Set up a timer to update device usage every minute
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateDeviceUsage();
    });

    // Initial update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDeviceUsage();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Update all active devices' usage time
  void _updateDeviceUsage() {
    if (!mounted) return;
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.updateAllDevicesUsage();
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: AppAnimations.mediumDuration,
      curve: AppAnimations.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe to change page
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.textGrey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.room_outlined),
                activeIcon: Icon(Icons.room),
                label: 'Rooms',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.devices_outlined),
                activeIcon: Icon(Icons.devices),
                label: 'Devices',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                activeIcon: Icon(Icons.chat),
                label: 'AI Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
