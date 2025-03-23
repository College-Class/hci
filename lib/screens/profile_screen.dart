import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/home_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final user = homeProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.primaryGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with blurred background
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    // Back button
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // Title
                    const Positioned(
                      top: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Profile info
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          // Profile image
                          Hero(
                            tag: 'profile_image',
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child:
                                  user.profileImageUrl != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          user.profileImageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color:
                                                        AppColors.primaryBlue,
                                                  ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors.primaryBlue,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // User info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        user.isPremium
                                            ? Colors.amber
                                            : Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user.isPremium ? 'Premium' : 'Standard',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          user.isPremium
                                              ? Colors.black
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Edit button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Settings sections
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Settings title
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),

                    // Account settings card
                    Card(
                      elevation: AppSizes.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadius,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Account button
                          _buildProfileMenuItem(
                            icon: Icons.person_outline,
                            title: 'My Account',
                            subtitle: 'Personal details and preferences',
                            onTap: () {},
                          ),

                          const Divider(height: 1, indent: 70),

                          // Premium button
                          _buildProfileMenuItem(
                            icon: Icons.diamond_outlined,
                            title: 'Get Premium',
                            subtitle: 'Upgrade to premium features',
                            iconColor: Colors.amber,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Preferences title
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),

                    // Preferences card
                    Card(
                      elevation: AppSizes.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadius,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Dark mode switch
                          _buildSwitchMenuItem(
                            icon: Icons.brightness_4_outlined,
                            title: 'Dark Mode',
                            subtitle: 'Enable dark theme',
                            value: _darkMode,
                            onChanged: (value) {
                              setState(() {
                                _darkMode = value;
                              });
                            },
                          ),

                          const Divider(height: 1, indent: 70),

                          // Notifications switch
                          _buildSwitchMenuItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Push notifications',
                            value: _notifications,
                            onChanged: (value) {
                              setState(() {
                                _notifications = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // More title
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        'More',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),

                    // More options card
                    Card(
                      elevation: AppSizes.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadius,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Help and support
                          _buildProfileMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help and Support',
                            subtitle: 'Contact us, FAQs',
                            onTap: () {},
                          ),

                          const Divider(height: 1, indent: 70),

                          // About app
                          _buildProfileMenuItem(
                            icon: Icons.info_outline,
                            title: 'About App',
                            subtitle: 'Version, terms & privacy',
                            onTap: () {},
                          ),

                          const Divider(height: 1, indent: 70),

                          // Logout button
                          _buildProfileMenuItem(
                            icon: Icons.logout,
                            title: 'Log Out',
                            subtitle: 'Sign out from this device',
                            iconColor: AppColors.errorRed,
                            textColor: AppColors.errorRed,
                            onTap: () async {
                              // Show confirmation dialog
                              final shouldLogout =
                                  await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Log Out'),
                                          content: const Text(
                                            'Are you sure you want to log out?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    AppColors.errorRed,
                                              ),
                                              child: const Text('Log Out'),
                                            ),
                                          ],
                                        ),
                                  ) ??
                                  false;

                              if (shouldLogout) {
                                await homeProvider.logout();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // App version
                    const Center(
                      child: Text(
                        'Smart Home v1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    Color iconColor = AppColors.primaryBlue,
    Color textColor = AppColors.primaryDark,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, size: 20, color: iconColor)),
            ),
            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchMenuItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    Color iconColor = AppColors.primaryBlue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, size: 20, color: iconColor)),
          ),
          const SizedBox(width: 16),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Switch
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
