import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../providers/home_provider.dart';
import '../widgets/device_card.dart';
import '../models/device_model.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = [
    'All',
    'Lights',
    'Air Conditioners',
    'Televisions',
    'Others',
  ];

  // Maps for device images and background colors
  final Map<String, String> _deviceImages = {
    'Smart Lighting': 'https://cdn-icons-png.flaticon.com/512/3106/3106693.png',
    'Air Condition': 'https://cdn-icons-png.flaticon.com/512/4743/4743301.png',
    'Fan': 'https://cdn-icons-png.flaticon.com/512/2399/2399397.png',
    'Smart Television':
        'https://cdn-icons-png.flaticon.com/512/2950/2950838.png',
    'Smart Speaker': 'https://cdn-icons-png.flaticon.com/512/2401/2401511.png',
    'Security Camera':
        'https://cdn-icons-png.flaticon.com/512/2452/2452153.png',
  };

  final Map<String, Color> _deviceColors = {
    'Smart Lighting': Colors.blue,
    'Air Condition': Colors.lightBlue,
    'Fan': Colors.blue,
    'Smart Television': Colors.grey.shade200,
    'Smart Speaker': Colors.orange,
    'Security Camera': Colors.red.shade400,
  };

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if we have filter arguments from navigation
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final categoryName = arguments['categoryName'] as String?;

      if (categoryName != null) {
        // Map category name to our internal category format
        switch (categoryName) {
          case 'Lights':
            setState(() {
              _selectedCategory = 'Lights';
            });
            break;
          case 'AC':
            setState(() {
              _selectedCategory = 'Air Conditioners';
            });
            break;
          case 'TVs':
            setState(() {
              _selectedCategory = 'Televisions';
            });
            break;
          case 'Others':
            setState(() {
              _selectedCategory = 'Others';
            });
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final allDevices = homeProvider.devices;

    // Filter devices based on category and search query
    List<Device> filteredDevices =
        allDevices.where((device) {
          // First filter by category
          bool matchesCategory =
              _selectedCategory == 'All' ||
              (_selectedCategory == 'Lights' &&
                  device.type == DeviceType.smartLight) ||
              (_selectedCategory == 'Air Conditioners' &&
                  device.type == DeviceType.airConditioner) ||
              (_selectedCategory == 'Televisions' &&
                  device.type == DeviceType.television) ||
              (_selectedCategory == 'Others' &&
                  device.type != DeviceType.smartLight &&
                  device.type != DeviceType.airConditioner &&
                  device.type != DeviceType.television);

          // Then filter by search query if needed
          bool matchesSearch =
              _searchQuery.isEmpty ||
              device.name.toLowerCase().contains(_searchQuery.toLowerCase());

          return matchesCategory && matchesSearch;
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Devices',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          // Navigate to add device screen
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search devices...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Category filter
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category),
                        showCheckmark: false,
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.primaryBlue.withOpacity(0.15),
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? AppColors.primaryBlue
                                  : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? AppColors.primaryBlue
                                    : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Devices count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${filteredDevices.length} ${filteredDevices.length == 1 ? 'Device' : 'Devices'}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Devices grid
              Expanded(
                child:
                    filteredDevices.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.78,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: filteredDevices.length,
                          itemBuilder: (context, index) {
                            final device = filteredDevices[index];

                            // Instead of using the DeviceCard, build a custom one for the mockup
                            return _buildDeviceCard(device, homeProvider);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(Device device, HomeProvider provider) {
    return GestureDetector(
      onTap: () {
        // Navigate to device detail
        Navigator.pushNamed(context, '/device_detail', arguments: device);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top part with device icon and toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getDeviceColor(device),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Device icon or image
                  _buildDeviceIconOrImage(device),

                  // Toggle switch
                  Switch(
                    value: device.isOn,
                    onChanged: (value) {
                      provider.toggleDeviceState(device.id);
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.4),
                  ),
                ],
              ),
            ),

            // Device info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Active time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(device.timeUsed),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Power consumption
                  Row(
                    children: [
                      Icon(Icons.bolt, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${device.currentConsumption.toStringAsFixed(1)} kWh',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceIconOrImage(Device device) {
    if (device.imageUrl != null &&
        device.imageUrl.isNotEmpty &&
        device.imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: device.imageUrl,
        width: 48,
        height: 48,
        imageBuilder:
            (context, imageProvider) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
        placeholder:
            (context, url) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
              ),
            ),
        errorWidget:
            (context, url, error) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getDeviceIcon(device),
                color: Colors.black87,
                size: 24,
              ),
            ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(_getDeviceIcon(device), color: Colors.black87, size: 24),
      );
    }
  }

  Color _getDeviceColor(Device device) {
    switch (device.type) {
      case DeviceType.smartLight:
        return AppColors.lightColor;
      case DeviceType.airConditioner:
        return AppColors.acColor;
      case DeviceType.television:
        return AppColors.tvColor;
      default:
        return AppColors.otherColor;
    }
  }

  IconData _getDeviceIcon(Device device) {
    switch (device.type) {
      case DeviceType.smartLight:
        return Icons.lightbulb_outline;
      case DeviceType.airConditioner:
        return Icons.ac_unit;
      case DeviceType.television:
        return Icons.tv;
      case DeviceType.fan:
        return Icons.toys;
      default:
        return Icons.devices_other;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices_other, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No devices found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'No devices in this category'
                : 'No devices match "$_searchQuery"',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
