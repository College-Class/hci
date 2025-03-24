import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/group_model.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;

  const GroupCard({Key? key, required this.group, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBlue,
                AppColors.primaryBlue.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group name and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getGroupIcon(group.type),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Group description
              Text(
                group.description,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Devices count
              Row(
                children: [
                  const Icon(Icons.devices, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${group.deviceIds.length} Devices',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Play button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Activate group
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Activate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getGroupIcon(String type) {
    switch (type) {
      case 'morning':
        return Icons.wb_sunny;
      case 'night':
        return Icons.nightlight_round;
      case 'away':
        return Icons.directions_walk;
      case 'movie':
        return Icons.movie;
      case 'party':
        return Icons.celebration;
      default:
        return Icons.auto_awesome;
    }
  }
}
