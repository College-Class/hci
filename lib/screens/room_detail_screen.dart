import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      backgroundColor: AppColors.primaryGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with room image
            Container(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  // Room image
                  Hero(
                    tag: 'room_image_${widget.room.id}',
                    child: Container(
                      width: double.infinity,
                      height: 200,
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
                        child: Image.asset(
                          widget.room.imageUrl,
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
                            Text(
                              widget.room.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black45, blurRadius: 5),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
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
                                        '${widget.room.totalDevices} Devices',
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
                                        widget.room.activeDevices > 0
                                            ? AppColors.successGreen
                                                .withOpacity(0.8)
                                            : Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        widget.room.activeDevices > 0
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.room.activeDevices} Active',
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
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.bolt,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.room.kwhUsage} kWh',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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

                  // Back button and add device button
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Add device button
                        GestureDetector(
                          onTap: () {
                            // Navigate to add device screen
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.add, color: Colors.white, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  'Add device',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: _selectedCategoryIndex == index,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryIndex = index;
                          _tabController.animateTo(index);
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.accentBlue,
                      labelStyle: TextStyle(
                        color:
                            _selectedCategoryIndex == index
                                ? AppColors.primaryBlue
                                : AppColors.textGrey,
                        fontWeight:
                            _selectedCategoryIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  );
                },
              ),
            ),

            // Device grid
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    _categories.map((category) {
                      // Filter devices based on selected category
                      List<Device> filteredDevices = devices;
                      if (category == 'Wifi') {
                        filteredDevices =
                            devices
                                .where(
                                  (d) =>
                                      d.connectionType == ConnectionType.wifi,
                                )
                                .toList();
                      } else if (category == 'Bluetooth') {
                        filteredDevices =
                            devices
                                .where(
                                  (d) =>
                                      d.connectionType ==
                                      ConnectionType.bluetooth,
                                )
                                .toList();
                      } else if (category == 'Zigbee') {
                        filteredDevices =
                            devices
                                .where(
                                  (d) =>
                                      d.connectionType == ConnectionType.zigbee,
                                )
                                .toList();
                      }

                      if (filteredDevices.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.devices,
                                size: 64,
                                color: AppColors.textGrey.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No ${category.toLowerCase()} devices found',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Navigate to add device screen
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Device'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: filteredDevices.length,
                        itemBuilder: (context, index) {
                          final device = filteredDevices[index];
                          return DeviceCard(
                            device: device,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/device_detail',
                                arguments: device,
                              );
                            },
                          );
                        },
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
