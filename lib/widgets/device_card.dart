import 'package:flutter/material.dart';
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
        decoration: BoxDecoration(
          color: device.isOn ? AppColors.primaryBlue : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 1,
            ),
          ],
          border:
              device.isOn
                  ? null
                  : Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device image and connection type icon
            Container(
              height: 110,
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Stack(
                children: [
                  Hero(
                    tag: 'device_image_${device.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusLarge,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              device.isOn
                                  ? AppColors.primaryBlue.withOpacity(0.8)
                                  : AppColors.primaryGrey,
                        ),
                        child: Image.asset(
                          device.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color:
                                    device.isOn
                                        ? AppColors.primaryBlue.withOpacity(0.8)
                                        : AppColors.primaryGrey,
                                child: Icon(
                                  device.icon,
                                  size: 50,
                                  color:
                                      device.isOn
                                          ? Colors.white70
                                          : Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            device.isOn
                                ? Colors.white.withOpacity(0.3)
                                : Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadius,
                        ),
                      ),
                      child: Icon(
                        device.connectionType == ConnectionType.wifi
                            ? Icons.wifi
                            : device.connectionType == ConnectionType.bluetooth
                            ? Icons.bluetooth
                            : Icons.settings_remote,
                        color: device.isOn ? Colors.white : Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Device name and details
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    'Active: ${device.timeUsed.inHours}h ${device.timeUsed.inMinutes.remainder(60)}min',
                    style: TextStyle(
                      fontSize: 12,
                      color: device.isOn ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.bolt,
                        size: 14,
                        color:
                            device.isOn ? Colors.amber : Colors.amber.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${device.currentConsumption} W',
                        style: TextStyle(
                          fontSize: 12,
                          color: device.isOn ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Toggle switch
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    device.isOn ? 'On' : 'Off',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: device.isOn ? Colors.white : Colors.black,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: device.isOn,
                      onChanged: (value) {
                        homeProvider.toggleDeviceState(device.id);
                      },
                      activeColor: Colors.white,
                      inactiveThumbColor: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
