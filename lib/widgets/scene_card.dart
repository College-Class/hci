import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/scene_model.dart';
import '../models/group_model.dart';
import '../providers/home_provider.dart';
import 'package:provider/provider.dart';

class Scene {
  final String id;
  final String name;
  final TimeOfDay? scheduleTime;
  final List<String> deviceIds;
  final Map<String, Map<String, dynamic>>? deviceSettings;
  final bool isActive;
  final List<String>? deviceImageUrls;

  Scene({
    required this.id,
    required this.name,
    this.scheduleTime,
    required this.deviceIds,
    this.deviceSettings,
    required this.isActive,
    this.deviceImageUrls,
  });

  // Create Scene from Group (for compatibility)
  factory Scene.fromGroup(Group group) {
    return Scene(
      id: group.id,
      name: group.name,
      deviceIds: group.deviceIds,
      isActive: group.isActive,
      deviceImageUrls: null,
    );
  }
}

class SceneCard extends StatelessWidget {
  final Scene scene;
  final VoidCallback? onTap;

  const SceneCard({Key? key, required this.scene, this.onTap})
    : super(key: key);

  // Compatibility constructor for Group objects
  factory SceneCard.fromGroup(Group group, {Key? key, VoidCallback? onTap}) {
    return SceneCard(key: key, scene: Scene.fromGroup(group), onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            scene.isActive ? AppColors.primaryBlue : AppColors.cardBackground,
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
            scene.isActive ? null : Border.all(color: AppColors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scene header with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      scene.isActive
                          ? [
                            AppColors.primaryBlue,
                            AppColors.primaryBlue.withBlue(180),
                          ]
                          : [Colors.grey.shade100, Colors.grey.shade200],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scene.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              scene.isActive
                                  ? Colors.white
                                  : AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color:
                                scene.isActive ? Colors.white70 : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            scene.scheduleTime != null
                                ? '${scene.scheduleTime!.hour}:${scene.scheduleTime!.minute.toString().padLeft(2, '0')}'
                                : 'Not scheduled',
                            style: TextStyle(
                              color:
                                  scene.isActive ? Colors.white70 : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // homeProvider.toggleSceneState(scene.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          scene.isActive ? Colors.white : AppColors.primaryBlue,
                      foregroundColor:
                          scene.isActive ? AppColors.primaryBlue : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: const Size(100, 36),
                      maximumSize: const Size(120, 36),
                      fixedSize: const Size(120, 36),
                    ),
                    child: Text(
                      scene.isActive ? 'Activated' : 'Activate',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Device images
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Devices',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          scene.isActive ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          (scene.deviceImageUrls?.length ?? 0) > 3
                              ? _buildDeviceImages(
                                scene.deviceImageUrls!.take(3).toList(),
                                scene.deviceImageUrls!.length - 3,
                                scene.isActive,
                              )
                              : _buildDeviceImages(
                                scene.deviceImageUrls ?? [],
                                0,
                                scene.isActive,
                              ),
                    ),
                  ),
                ],
              ),
            ),

            // Toggle switch
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // On/Off label
                  Text(
                    scene.isActive ? 'On' : 'Off',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          scene.isActive ? Colors.white : AppColors.primaryDark,
                    ),
                  ),

                  // Switch
                  Switch(
                    value: scene.isActive,
                    onChanged: (value) {
                      // homeProvider.toggleSceneState(scene.id);
                    },
                    activeColor: Colors.white,
                    inactiveThumbColor: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDeviceImages(
    List<String> imageUrls,
    int extraCount,
    bool isActive,
  ) {
    List<Widget> widgets = [];

    for (var url in imageUrls) {
      widgets.add(
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(
              color:
                  isActive
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius - 1),
            child: Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color:
                        isActive
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.shade200,
                    child: Icon(
                      Icons.devices_other,
                      size: 30,
                      color: isActive ? Colors.white54 : Colors.grey,
                    ),
                  ),
            ),
          ),
        ),
      );
    }

    // Add the "+X Others" widget if needed
    if (extraCount > 0) {
      widgets.add(
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color:
                isActive ? Colors.white.withOpacity(0.2) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(
              color:
                  isActive
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.borderColor,
            ),
          ),
          child: Center(
            child: Text(
              '+$extraCount\nOthers',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
