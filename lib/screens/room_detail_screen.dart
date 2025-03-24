import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../models/device_model.dart';
import '../models/room_model.dart';
import '../providers/home_provider.dart';
import '../widgets/device_card.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;

  const RoomDetailScreen({Key? key, required this.room}) : super(key: key);

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['All', 'Wifi', 'Bluetooth', 'Zigbee'];
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedCategoryIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final devices = homeProvider.getDevicesForRoom(widget.room.id);
    final currentRoom = homeProvider.getRoomById(widget.room.id);

    if (currentRoom == null) {
      return const Scaffold(body: Center(child: Text('Room not found')));
    }

    // Filter devices based on selected category
    List<Device> filteredDevices = devices;
    if (_selectedCategoryIndex == 1) {
      // Wifi
      filteredDevices =
          devices
              .where((d) => d.connectionType == ConnectionType.wifi)
              .toList();
    } else if (_selectedCategoryIndex == 2) {
      // Bluetooth
      filteredDevices =
          devices
              .where((d) => d.connectionType == ConnectionType.bluetooth)
              .toList();
    } else if (_selectedCategoryIndex == 3) {
      // Zigbee
      filteredDevices =
          devices
              .where((d) => d.connectionType == ConnectionType.zigbee)
              .toList();
    }

    final int activeDevicesCount =
        devices.where((device) => device.isOn).length;

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
          currentRoom.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          // Room info button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                // Show room info dialog or navigate to room settings
              },
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with room image
          Container(
            height: 250,
            width: double.infinity,
            child: Stack(
              children: [
                // Room image
                Hero(
                  tag: 'room_image_${currentRoom.id}',
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
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
                          currentRoom.imageUrl.startsWith('http')
                              ? CachedNetworkImage(
                                imageUrl: currentRoom.imageUrl,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.home,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                              : Image.asset(
                                currentRoom.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.home,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                    ),
                  ),
                ),

                // Gradient overlay for better text readability
                Container(
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

                // Room information overlay
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.devices,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${devices.length} Devices',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      activeDevicesCount > 0
                                          ? AppColors.successGreen.withOpacity(
                                            0.8,
                                          )
                                          : Colors.red.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      activeDevicesCount > 0
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$activeDevicesCount Active',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
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

                      // Room energy usage
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Energy',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.bolt, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${currentRoom.totalConsumption} W',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Category tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Devices',
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            height: 50,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primaryBlue,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor: Colors.grey,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),

          // Device grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: AnimatedSwitcher(
                duration: AppAnimations.mediumDuration,
                child:
                    filteredDevices.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                          key: ValueKey<int>(_selectedCategoryIndex),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: filteredDevices.length,
                          padding: const EdgeInsets.only(bottom: 16),
                          itemBuilder: (context, index) {
                            return DeviceCard(
                              device: filteredDevices[index],
                              isDetailed: true,
                            );
                          },
                        ),
              ),
            ),
          ),
        ],
      ),
    );
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
            _selectedCategoryIndex == 0
                ? 'Add some devices to this room'
                : 'No ${_categories[_selectedCategoryIndex]} devices in this room',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add device screen (would be implemented in a real app)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add device functionality would go here'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Device'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
