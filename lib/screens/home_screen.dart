import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_constants.dart';
import '../providers/home_provider.dart';
import '../models/device_model.dart';
import '../models/room_model.dart';
import '../models/group_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showLineChart = true; // Track which chart type to show
  bool _showWeeklyData = true; // Track whether to show weekly or monthly data
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final userName = homeProvider.currentUser.name;
    final groups = homeProvider.groups;
    final rooms = homeProvider.rooms;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldBackground,
      drawer: _buildDrawer(context, homeProvider),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar with menu and profile
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu button
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.menu, color: AppColors.primaryBlue),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ),

                      // Profile avatar
                      InkWell(
                        onTap: () {
                          // Navigate to profile
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // Welcome Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HOME,',
                        style: TextStyle(
                          fontSize: 32,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome $userName',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Daily Groups Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Groups',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Groups list or card
                      if (groups.isNotEmpty)
                        _buildGroupCard(groups.first, homeProvider)
                      else
                        _buildEmptyGroupCard(),

                      const SizedBox(height: 12),

                      // Create more groups button
                      InkWell(
                        onTap: () {
                          // Navigate to create group
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create more groups',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Device Categories
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDeviceCategory(
                          'AC',
                          '0${homeProvider.airConditionersCount}',
                          AppColors.acColor,
                          Icons.ac_unit,
                        ),
                        _buildDeviceCategory(
                          'Lights',
                          '0${homeProvider.smartLightsCount}',
                          AppColors.lightColor,
                          Icons.lightbulb_outline,
                        ),
                        _buildDeviceCategory(
                          'TVs',
                          '0${homeProvider.televisionCount}',
                          AppColors.tvColor,
                          Icons.tv,
                        ),
                        _buildDeviceCategory(
                          'Others',
                          '03', // Placeholder count
                          AppColors.otherColor,
                          Icons.devices_other,
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Visit
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Visit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to all rooms
                            },
                            child: Row(
                              children: [
                                Text(
                                  'See All',
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.primaryBlue,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rooms list
                      ...rooms
                          .take(2)
                          .map(
                            (room) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildRoomCard(room, homeProvider),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),

                // Power Consumption Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Power Consumption',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Power consumption card would go here
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Today's usage
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bolt,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${homeProvider.todayConsumption.toStringAsFixed(1)} kWh',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Consumption Chart
                            _buildPowerConsumptionChart(homeProvider),

                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),

                            // Monthly usage
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'This Month',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bolt,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${homeProvider.totalConsumption.toStringAsFixed(1)} kWh',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacer at bottom for navigation bar
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(Group group, HomeProvider provider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, Colors.teal],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Not scheduled',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Devices',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 60), // Placeholder for devices list

          const Divider(color: Colors.white24),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group.isActive ? 'On' : 'Off',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Switch(
                  value: group.isActive,
                  onChanged: (value) {
                    provider.toggleGroupState(group.id);
                  },
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.white,
                  trackColor: MaterialStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white.withOpacity(0.3);
                    }
                    return Colors.white30;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyGroupCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'No groups created yet',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget _buildDeviceCategory(
    String name,
    String count,
    Color color,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to devices screen with filter
        DeviceType? filterType;

        switch (name) {
          case 'AC':
            filterType = DeviceType.airConditioner;
            break;
          case 'Lights':
            filterType = DeviceType.smartLight;
            break;
          case 'TVs':
            filterType = DeviceType.television;
            break;
          case 'Others':
            // Others will be handled in the devices screen
            break;
        }

        // Navigate to Devices tab in MainNavigationScreen with filter
        Navigator.pushReplacementNamed(
          context,
          '/main',
          arguments: 2, // Index 2 for Devices tab
        );

        // Pass the filter arguments to the next screen using a delayed callback
        // to ensure MainNavigationScreen is built
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.pushNamed(
            context,
            '/devices',
            arguments: {'filterType': filterType, 'categoryName': name},
          );
        });
      },
      borderRadius: BorderRadius.circular(32), // Circular splash effect
      highlightColor: color.withOpacity(0.1),
      splashColor: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.black87, size: 30),
            ),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(Room room, HomeProvider provider) {
    final devices = provider.getDevicesForRoom(room.id);
    final activeDevices = devices.where((d) => d.isOn).length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image:
              room.imageUrl.startsWith('http')
                  ? NetworkImage(room.imageUrl) as ImageProvider
                  : AssetImage(room.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        children: [
          // Room name and power consumption
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${room.totalConsumption} W',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Devices count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.devices, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${room.totalDevices} Devices',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Home icon (placeholder, not functional)
          Center(
            child: Icon(
              Icons.home,
              color: Colors.white.withOpacity(0.5),
              size: 50,
            ),
          ),

          // Active devices
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${room.kwhUsage} Kwh',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$activeDevices Active',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'of ${room.totalDevices}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerConsumptionChart(HomeProvider provider) {
    final data =
        _showWeeklyData
            ? provider.weeklyConsumptionData
            : provider.monthlyConsumptionData;

    // Find max value for scaling
    final maxConsumption = data
        .map((d) => d['consumption'] as double)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Data period toggle (Weekly/Monthly)
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showWeeklyData = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Weekly',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          _showWeeklyData ? FontWeight.bold : FontWeight.normal,
                      color:
                          _showWeeklyData
                              ? AppColors.primaryBlue
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
                Text(' | ', style: TextStyle(color: Colors.grey.shade400)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showWeeklyData = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Monthly',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          !_showWeeklyData
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          !_showWeeklyData
                              ? AppColors.primaryBlue
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),

            // Chart type toggle (Line/Bar)
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.show_chart,
                    color:
                        _showLineChart
                            ? AppColors.primaryBlue
                            : Colors.grey.shade400,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _showLineChart = true;
                    });
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.bar_chart,
                    color:
                        !_showLineChart
                            ? AppColors.primaryBlue
                            : Colors.grey.shade400,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _showLineChart = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 180,
          child:
              _showLineChart
                  ? _buildLineChart(data, maxConsumption)
                  : _buildBarChart(data, maxConsumption),
        ),

        // AI recommendation
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'AI Recommendation: Turn off unused devices to save energy',
                style: TextStyle(color: AppColors.primaryBlue, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(
    List<Map<String, dynamic>> data,
    double maxConsumption,
  ) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Text(
                    _showWeeklyData ? data[index]['day'] : data[index]['month'],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                );
              },
              reservedSize: 42,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxConsumption * 1.2,
        lineTouchData: LineTouchData(enabled: true),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index]['consumption']),
            ),
            isCurved: true,
            color: AppColors.primaryBlue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryBlue.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(
    List<Map<String, dynamic>> data,
    double maxConsumption,
  ) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Text(
                    _showWeeklyData ? data[index]['day'] : data[index]['month'],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                );
              },
              reservedSize: 42,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            data.asMap().entries.map((entry) {
              // Make bars different colors based on consumption
              final consumption = entry.value['consumption'] as double;
              final percentOfMax = consumption / maxConsumption;

              // Generate a color from blue to green based on consumption
              final color = _getBarColor(percentOfMax);

              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: consumption,
                    color: color,
                    width: _showWeeklyData ? 20 : 30,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxConsumption * 1.2,
                      color: Colors.grey.shade100,
                    ),
                  ),
                ],
                showingTooltipIndicators: [0], // Show tooltip for this bar
              );
            }).toList(),
        maxY: maxConsumption * 1.2,
        barTouchData: BarTouchData(enabled: true),
      ),
    );
  }

  // Generate color from blue to green based on consumption percentage
  Color _getBarColor(double percentOfMax) {
    if (percentOfMax < 0.3) {
      return Colors.green.shade400; // Low consumption - green
    } else if (percentOfMax < 0.6) {
      return Colors.blue.shade400; // Medium consumption - blue
    } else if (percentOfMax < 0.8) {
      return Colors.amber; // High consumption - amber
    } else {
      return Colors.orange; // Very high consumption - orange
    }
  }

  Widget _buildDrawer(BuildContext context, HomeProvider provider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header with user info
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryBlue),
            accountName: Text(
              provider.currentUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(provider.currentUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primaryBlue, size: 40),
            ),
          ),

          // Home
          ListTile(
            leading: Icon(Icons.home, color: AppColors.primaryBlue),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Already on home screen
            },
          ),

          // Rooms
          ListTile(
            leading: Icon(Icons.meeting_room, color: AppColors.primaryBlue),
            title: const Text('Rooms'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/rooms');
            },
          ),

          // Devices
          ListTile(
            leading: Icon(Icons.devices, color: AppColors.primaryBlue),
            title: const Text('Devices'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/devices');
            },
          ),

          // Groups
          ListTile(
            leading: Icon(Icons.group_work, color: AppColors.primaryBlue),
            title: const Text('Groups'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate to groups screen or section
            },
          ),

          const Divider(),

          // Settings
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.primaryBlue),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/settings');
            },
          ),

          // Help & Support
          ListTile(
            leading: Icon(Icons.help_outline, color: AppColors.primaryBlue),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Navigate to help screen
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          provider.logout().then((_) {
                            Navigator.pushReplacementNamed(context, '/login');
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
