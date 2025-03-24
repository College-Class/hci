import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../models/device_model.dart';
import '../providers/home_provider.dart';
import 'package:provider/provider.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final bool isDetailed;
  final VoidCallback? onTap;

  const DeviceCard({
    Key? key,
    required this.device,
    this.isDetailed = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.pushNamed(context, '/device_detail', arguments: device);
          },
      child: AnimatedContainer(
        duration: AppAnimations.mediumDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: device.isOn ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device icon or image
            Expanded(flex: 3, child: Center(child: _buildDeviceIconOrImage())),

            // Device name and details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMedium,
                  vertical: AppSizes.paddingSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device name
                    Text(
                      device.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: device.isOn ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Only show active time if device is on
                    if (device.isOn)
                      Text(
                        'Active: ${device.timeUsed.inHours}h ${device.timeUsed.inMinutes.remainder(60)}min',
                        style: TextStyle(
                          fontSize: 12,
                          color: device.isOn ? Colors.white70 : Colors.black54,
                        ),
                      )
                    else
                      Text(
                        'Off',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),

                    const SizedBox(height: 4),

                    // Power consumption
                    Row(
                      children: [
                        Icon(
                          Icons.bolt,
                          size: 14,
                          color:
                              device.isOn
                                  ? Colors.white
                                  : Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${device.currentConsumption} W',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                device.isOn ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Additional settings for air conditioner
                    if (isDetailed &&
                        device.type == DeviceType.airConditioner &&
                        device.isOn)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              _getAirConditionerModeIcon(),
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${device.additionalSettings['temperature'] ?? 24}°C',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Spacer(),

                    // Toggle switch
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: device.isOn,
                          onChanged: (value) {
                            _handleDeviceToggle(homeProvider);
                          },
                          activeColor: Colors.white,
                          inactiveThumbColor: AppColors.primaryBlue,
                          trackColor: MaterialStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.white.withOpacity(0.3);
                            }
                            return Colors.grey.withOpacity(0.3);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceIconOrImage() {
    if (device.imageUrl != null &&
        device.imageUrl.isNotEmpty &&
        device.imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: device.imageUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        imageBuilder:
            (context, imageProvider) => Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: device.isOn ? Colors.white24 : Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
        placeholder:
            (context, url) => Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: device.isOn ? Colors.white24 : _getDeviceColor(),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        errorWidget: (context, url, error) => _buildDeviceIcon(),
      );
    } else {
      return _buildDeviceIcon();
    }
  }

  Color _getDeviceColor() {
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

  Widget _buildDeviceIcon() {
    IconData iconData;
    Color iconBackgroundColor;

    switch (device.type) {
      case DeviceType.smartLight:
        iconData = Icons.lightbulb_outline;
        iconBackgroundColor = AppColors.lightColor;
        break;
      case DeviceType.airConditioner:
        iconData = Icons.ac_unit;
        iconBackgroundColor = AppColors.acColor;
        break;
      case DeviceType.television:
        iconData = Icons.tv;
        iconBackgroundColor = AppColors.tvColor;
        break;
      case DeviceType.fan:
        iconData = Icons.air;
        iconBackgroundColor = AppColors.otherColor;
        break;
      default:
        iconData = Icons.devices_other;
        iconBackgroundColor = AppColors.otherColor;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: device.isOn ? Colors.white24 : iconBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: device.isOn ? Colors.white : Colors.black87,
        size: 24,
      ),
    );
  }

  void _handleDeviceToggle(HomeProvider homeProvider) {
    homeProvider.toggleDeviceState(device.id);

    // Update consumption values based on state
    if (device.isOn) {
      // Device was just turned on
      final Map<String, dynamic> updates = {};

      if (device.type == DeviceType.airConditioner) {
        if (!device.additionalSettings.containsKey('mode')) {
          updates['mode'] = 'Heat';
        }
        if (!device.additionalSettings.containsKey('temperature')) {
          updates['temperature'] = 24;
        }
        if (!device.additionalSettings.containsKey('fanSpeed')) {
          updates['fanSpeed'] = 'Auto';
        }
      } else if (device.type == DeviceType.smartLight) {
        if (!device.additionalSettings.containsKey('brightness')) {
          updates['brightness'] = 70;
        }
      }

      if (updates.isNotEmpty) {
        homeProvider.updateDeviceSettings(device.id, updates);
      }
    }
  }

  IconData _getAirConditionerModeIcon() {
    final mode = device.additionalSettings['mode'] as String? ?? 'Heat';

    switch (mode) {
      case 'Heat':
        return Icons.whatshot;
      case 'Cool':
        return Icons.ac_unit;
      case 'Fan':
        return Icons.air;
      case 'Auto':
      default:
        return Icons.auto_mode;
    }
  }
}
