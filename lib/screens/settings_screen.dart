import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  bool _isLocationEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTemperatureUnit = 'Celsius';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  final List<String> _temperatureUnits = ['Celsius', 'Fahrenheit'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryBlue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit profile
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // App settings
            _buildSection(
              title: 'App Settings',
              children: [
                _buildSettingTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                  ),
                ),
                _buildSettingTile(
                  icon: Icons.language,
                  title: 'Language',
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                    items:
                        _languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Notifications
            _buildSection(
              title: 'Notifications',
              children: [
                _buildSettingTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  trailing: Switch(
                    value: _isNotificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isNotificationsEnabled = value;
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                  ),
                ),
                _buildSettingTile(
                  icon: Icons.location_on,
                  title: 'Location Services',
                  trailing: Switch(
                    value: _isLocationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isLocationEnabled = value;
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Preferences
            _buildSection(
              title: 'Preferences',
              children: [
                _buildSettingTile(
                  icon: Icons.thermostat,
                  title: 'Temperature Unit',
                  trailing: DropdownButton<String>(
                    value: _selectedTemperatureUnit,
                    onChanged: (value) {
                      setState(() {
                        _selectedTemperatureUnit = value!;
                      });
                    },
                    items:
                        _temperatureUnits.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Account
            _buildSection(
              title: 'Account',
              children: [
                _buildSettingTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () {
                    // Navigate to change password screen
                  },
                ),
                _buildSettingTile(
                  icon: Icons.security,
                  title: 'Two-Factor Authentication',
                  onTap: () {
                    // Navigate to 2FA settings
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // About
            _buildSection(
              title: 'About',
              children: [
                _buildSettingTile(
                  icon: Icons.info,
                  title: 'App Version',
                  trailing: const Text('1.0.0'),
                ),
                _buildSettingTile(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  onTap: () {
                    // Navigate to terms of service
                  },
                ),
                _buildSettingTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Logout button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
