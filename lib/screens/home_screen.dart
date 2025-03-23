import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/home_provider.dart';
import '../widgets/device_card.dart';
import '../widgets/room_card.dart';
import '../widgets/scene_card.dart';
import 'room_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.mediumDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final userName = homeProvider.currentUser.name;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryGrey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: AppColors.primaryGrey,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with menu and profile
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu, size: 24),
                          color: AppColors.primaryBlue,
                        ),
                      ),

                      // Profile button
                      GestureDetector(
                        onTap: () {
                          // Navigate to profile screen using named route
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Hero(
                          tag: 'profile_image',
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardBackground,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryBlue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Welcome text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HOME,',
                        style: AppTextStyles.heading1.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      Text(
                        'Welcome $userName',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Daily scene section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Daily Scene',
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Scene cards
                if (homeProvider.scenes.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SceneCard(scene: homeProvider.scenes.first),
                  ),
                  const SizedBox(height: 16),
                ],

                // Create more scenes button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 0,
                    color: AppColors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                      side: BorderSide(color: AppColors.borderColor),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to create scene screen
                      },
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Create more scenes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Power consumption card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: AppSizes.cardElevation,
                    shadowColor: AppColors.shadowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.bolt,
                                color: Colors.amber,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Power Consumption',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Today's consumption
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Today's consumption
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Today',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${homeProvider.todayConsumption.toInt()}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            'W',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Total consumption
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${homeProvider.totalConsumption.toInt()}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            'W',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Devices On section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: AppSizes.cardElevation,
                    shadowColor: AppColors.shadowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.devices,
                                color: AppColors.primaryBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Devices On',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Device types with counts
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Air Conditioners
                              _buildDeviceTypeCard(
                                icon: Icons.ac_unit,
                                title: 'AC',
                                count: homeProvider.airConditionersCount
                                    .toString()
                                    .padLeft(2, '0'),
                                color: Colors.blue.shade300,
                              ),

                              // Smart Lights
                              _buildDeviceTypeCard(
                                icon: Icons.lightbulb_outline,
                                title: 'Lights',
                                count: homeProvider.smartLightsCount
                                    .toString()
                                    .padLeft(2, '0'),
                                color: Colors.amber.shade300,
                              ),

                              // Smart Television
                              _buildDeviceTypeCard(
                                icon: Icons.tv,
                                title: 'TVs',
                                count: homeProvider.televisionCount
                                    .toString()
                                    .padLeft(2, '0'),
                                color: Colors.purple.shade300,
                              ),

                              // Others (placeholder)
                              _buildDeviceTypeCard(
                                icon: Icons.devices_other,
                                title: 'Others',
                                count: '03',
                                color: Colors.teal.shade300,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Visit section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Visit',
                        style: AppTextStyles.heading3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Navigate to all rooms screen
                        },
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('See All'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Room cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children:
                        homeProvider.rooms
                            .take(2) // Only show first 2 rooms to avoid clutter
                            .map(
                              (room) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: RoomCard(
                                  room: room,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/room_detail',
                                      arguments: room,
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),

      // Add bottom navigation bar for better navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              switch (index) {
                case 0: // Home
                  // Already on home screen
                  break;
                case 1: // Rooms
                  // Show rooms in a dedicated view or navigate to a rooms screen
                  if (homeProvider.rooms.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      '/room_detail',
                      arguments: homeProvider.rooms.first,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No rooms available')),
                    );
                  }
                  break;
                case 2: // Devices
                  // Show all devices
                  _scaffoldKey.currentState?.openDrawer();
                  break;
                case 3: // Profile
                  Navigator.pushNamed(context, '/profile');
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 0,
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
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),

      // Drawer for menu
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drawer header
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              homeProvider.currentUser.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Menu items
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  isSelected: _currentIndex == 0,
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                    Navigator.pop(context); // Close drawer
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.room_outlined,
                  title: 'Rooms',
                  isSelected: _currentIndex == 1,
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                    Navigator.pop(context); // Close drawer
                    // You can navigate to a dedicated Rooms screen here if needed
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.devices_outlined,
                  title: 'Devices',
                  isSelected: _currentIndex == 2,
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                    Navigator.pop(context); // Close drawer
                    // You can navigate to a dedicated Devices screen here if needed
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Scenes',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    // Scroll to scenes section
                    // This is a simple implementation - you might want to use a ScrollController for better control
                    Future.delayed(Duration(milliseconds: 300), () {
                      // Scroll to scenes section
                    });
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    // Navigate to settings
                  },
                ),

                const Spacer(),

                // Logout section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: Colors.red,
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to logout?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Implement logout logic
                                    // For now, just go back to login screen
                                    Navigator.of(
                                      context,
                                    ).pushReplacementNamed('/login');
                                  },
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceTypeCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? AppColors.primaryBlue
                      : textColor ?? AppColors.textGrey,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected
                        ? AppColors.primaryBlue
                        : textColor ?? AppColors.textGrey,
                fontSize: 16,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
