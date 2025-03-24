import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../models/device_model.dart';
import '../providers/home_provider.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  double _brightness = 70;
  String _selectedMode = 'Heat';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _startTime = const TimeOfDay(hour: 11, minute: 0);
    _endTime = const TimeOfDay(hour: 18, minute: 0);

    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.mediumDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Initialize settings based on device type
    if (widget.device.type == DeviceType.airConditioner) {
      _selectedMode = widget.device.additionalSettings['mode'] ?? 'Heat';
    } else if (widget.device.type == DeviceType.smartLight) {
      _brightness =
          widget.device.additionalSettings['brightness']?.toDouble() ?? 70;
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
    final currentDevice = homeProvider.getDeviceById(widget.device.id);

    // Needed to get live updates of the device
    if (currentDevice == null) {
      return const Scaffold(body: Center(child: Text('Device not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.primaryGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          currentDevice.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          // Power toggle
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                homeProvider.toggleDeviceState(currentDevice.id);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      currentDevice.isOn
                          ? AppColors.successGreen.withOpacity(0.8)
                          : Colors.red.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  currentDevice.isOn ? Icons.power : Icons.power_off,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with device image
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Device image
                      Positioned.fill(
                        child: Hero(
                          tag: 'device_image_${currentDevice.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  currentDevice.isOn
                                      ? AppColors.primaryBlue.withOpacity(0.8)
                                      : Colors.grey.withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                              child:
                                  currentDevice.imageUrl.startsWith('http')
                                      ? CachedNetworkImage(
                                        imageUrl: currentDevice.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.primaryBlue,
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Center(
                                              child: Icon(
                                                _getDeviceIcon(currentDevice),
                                                size: 80,
                                                color:
                                                    currentDevice.isOn
                                                        ? Colors.white70
                                                        : Colors.grey,
                                              ),
                                            ),
                                      )
                                      : Image.asset(
                                        currentDevice.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Center(
                                                  child: Icon(
                                                    _getDeviceIcon(
                                                      currentDevice,
                                                    ),
                                                    size: 80,
                                                    color:
                                                        currentDevice.isOn
                                                            ? Colors.white70
                                                            : Colors.grey,
                                                  ),
                                                ),
                                      ),
                            ),
                          ),
                        ),
                      ),

                      // Gradient overlay for better text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                              stops: const [0.0, 0.3, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Device information overlay
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getDeviceIcon(currentDevice),
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        currentDevice.model,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        currentDevice.isOn
                                            ? AppColors.successGreen
                                                .withOpacity(0.8)
                                            : Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        currentDevice.isOn
                                            ? Icons.power
                                            : Icons.power_off,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        currentDevice.isOn ? 'On' : 'Off',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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

                const SizedBox(height: AppSizes.paddingLarge),

                // Device status
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  child: _buildDeviceStatusCard(currentDevice),
                ),

                const SizedBox(height: AppSizes.paddingLarge),

                // Device settings
                _buildDeviceSettings(homeProvider),

                const SizedBox(height: AppSizes.paddingLarge),

                // Energy usage
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  child: _buildEnergyUsageCard(currentDevice),
                ),

                const SizedBox(height: AppSizes.paddingLarge),

                // Schedule panel (simplified)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  child: _buildScheduleCard(),
                ),

                const SizedBox(height: AppSizes.paddingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceStatusCard(Device device) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Device Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                              device.isOn ? AppColors.successGreen : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        device.isOn ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              device.isOn ? AppColors.successGreen : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Connection type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Connection',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        device.connectionType == ConnectionType.wifi
                            ? Icons.wifi
                            : device.connectionType == ConnectionType.bluetooth
                            ? Icons.bluetooth
                            : Icons.settings_remote,
                        size: 16,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        device.connectionType == ConnectionType.wifi
                            ? 'Wi-Fi'
                            : device.connectionType == ConnectionType.bluetooth
                            ? 'Bluetooth'
                            : 'Zigbee',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Current consumption
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Power',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.bolt, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        '${device.currentConsumption} W',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          if (device.isOn) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              _getStatusMessage(device),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusMessage(Device device) {
    switch (device.type) {
      case DeviceType.airConditioner:
        final mode = device.additionalSettings['mode'] as String? ?? 'Heat';
        final temp = device.additionalSettings['temperature'] as int? ?? 24;
        return 'Running in $mode mode at $temp°C';
      case DeviceType.smartLight:
        final brightness =
            device.additionalSettings['brightness'] as int? ?? 70;
        return 'Light is on at $brightness% brightness';
      case DeviceType.fan:
        final speed = device.additionalSettings['speed'] as int? ?? 3;
        return 'Fan is running at speed $speed';
      case DeviceType.television:
        final source =
            device.additionalSettings['source'] as String? ?? 'HDMI 1';
        return 'TV is on $source input';
      default:
        return 'Device is running normally';
    }
  }

  Widget _buildEnergyUsageCard(Device device) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Energy Usage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEnergyUsageItem(
                'Current',
                '${device.currentConsumption} W',
                Icons.flash_on,
                AppColors.primaryBlue,
              ),
              _buildEnergyUsageItem(
                'Total',
                '${device.totalConsumption.toStringAsFixed(1)} kWh',
                Icons.insert_chart,
                Colors.orange,
              ),
              _buildEnergyUsageItem(
                'Active Time',
                '${device.timeUsed.inHours}h ${device.timeUsed.inMinutes.remainder(60)}m',
                Icons.access_time,
                Colors.green,
              ),
            ],
          ),

          // Could add a Chart here in a more complete implementation
        ],
      ),
    );
  }

  Widget _buildEnergyUsageItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              Switch(
                value: true, // Just a mock value
                onChanged: (value) {
                  // In a real app, this would toggle the schedule
                },
                activeColor: AppColors.primaryBlue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );
                        if (picked != null && picked != _startTime) {
                          setState(() {
                            _startTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _startTime.format(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End Time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                        );
                        if (picked != null && picked != _endTime) {
                          setState(() {
                            _endTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _endTime.format(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would save the schedule
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Schedule saved'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Save Schedule'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSettings(HomeProvider homeProvider) {
    // Implementation of _buildDeviceSettings method
    // This method should return a widget that represents the device settings section
    // For example, you can use a form to update device settings
    return Container(); // Placeholder return, actual implementation needed
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
}
