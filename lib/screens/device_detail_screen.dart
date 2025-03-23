import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      backgroundColor: AppColors.primaryGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with device image
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Device image
                      Positioned.fill(
                        child: Hero(
                          tag: 'device_image_${widget.device.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  widget.device.isOn
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
                              child: Image.asset(
                                widget.device.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Center(
                                      child: Icon(
                                        widget.device.icon,
                                        size: 80,
                                        color:
                                            widget.device.isOn
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
                            Text(
                              widget.device.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black45, blurRadius: 5),
                                ],
                              ),
                            ),
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
                                        widget.device.icon,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.device.model,
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
                                        widget.device.isOn
                                            ? AppColors.successGreen
                                                .withOpacity(0.8)
                                            : Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        widget.device.isOn
                                            ? Icons.power
                                            : Icons.power_off,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.device.isOn ? 'On' : 'Off',
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

                      // Back button and power toggle
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

                            // Power toggle button
                            GestureDetector(
                              onTap: () {
                                homeProvider.toggleDeviceState(
                                  widget.device.id,
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      widget.device.isOn
                                          ? AppColors.successGreen.withOpacity(
                                            0.8,
                                          )
                                          : Colors.red.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    widget.device.isOn
                                        ? Icons.power_settings_new
                                        : Icons.power_off,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Usage stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: AppSizes.cardElevation,
                    shadowColor: AppColors.shadowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Usage Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Device usage and status info
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.timer_outlined,
                                          size: 18,
                                          color: AppColors.textGrey,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Time Active',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${widget.device.timeUsed.inHours}h ${widget.device.timeUsed.inMinutes.remainder(60)}m',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.grey[300],
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.bolt,
                                            size: 18,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Power Usage',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${widget.device.currentConsumption}W',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Schedule section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: AppSizes.cardElevation,
                    shadowColor: AppColors.shadowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Schedule title and toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    color: AppColors.primaryBlue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Schedule',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: true,
                                onChanged: (value) {
                                  // Toggle schedule
                                },
                                activeColor: AppColors.primaryBlue,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // From-To time selectors
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // From time
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'From',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          final TimeOfDay? picked =
                                              await showTimePicker(
                                                context: context,
                                                initialTime: _startTime,
                                              );
                                          if (picked != null &&
                                              picked != _startTime) {
                                            setState(() {
                                              _startTime = picked;
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: AppColors.primaryBlue,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')} ${_startTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Divider
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),

                                // To time
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'To',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            final TimeOfDay? picked =
                                                await showTimePicker(
                                                  context: context,
                                                  initialTime: _endTime,
                                                );
                                            if (picked != null &&
                                                picked != _endTime) {
                                              setState(() {
                                                _endTime = picked;
                                              });
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time,
                                                size: 16,
                                                color: AppColors.primaryBlue,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${_endTime.hour}:${_endTime.minute.toString().padLeft(2, '0')} ${_endTime.period == DayPeriod.am ? 'PM' : 'AM'}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Days selection
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Days',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildDayCircle('M', true),
                                      _buildDayCircle('T', true),
                                      _buildDayCircle('W', true),
                                      _buildDayCircle('T', true),
                                      _buildDayCircle('F', true),
                                      _buildDayCircle('S', false),
                                      _buildDayCircle('S', false),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Device specific controls
                if (widget.device.type == DeviceType.smartLight) ...[
                  // Brightness slider for smart lights
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: AppSizes.cardElevation,
                      shadowColor: AppColors.shadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadius,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Brightness',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${_brightness.round()}%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.brightness_low,
                                  size: 20,
                                  color: AppColors.textGrey,
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _brightness,
                                    min: 0,
                                    max: 100,
                                    divisions: 10,
                                    label: _brightness.round().toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        _brightness = value;
                                      });
                                      homeProvider.updateDeviceSettings(
                                        widget.device.id,
                                        {'brightness': value.round()},
                                      );
                                    },
                                  ),
                                ),
                                const Icon(
                                  Icons.brightness_high,
                                  size: 20,
                                  color: AppColors.textGrey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else if (widget.device.type == DeviceType.airConditioner) ...[
                  // Mode selection for air conditioners
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: AppSizes.cardElevation,
                      shadowColor: AppColors.shadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadius,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.mode,
                                  color: AppColors.primaryBlue,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Mode Selection',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildModeButton('Heat', Colors.red[300]!),
                                  _buildModeButton('Cold', Colors.blue[300]!),
                                  _buildModeButton('Air', Colors.green[300]!),
                                  _buildModeButton(
                                    'Humid',
                                    Colors.purple[300]!,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Energy consumption card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: AppSizes.cardElevation,
                    shadowColor: AppColors.shadowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.bolt,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Energy Consumption',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Energy consumption graph placeholder
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.insert_chart_outlined,
                                    size: 48,
                                    color: AppColors.textGrey,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Consumption History',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Today',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${widget.device.currentConsumption * 3} Wh',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        color: Colors.grey[300],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'This Month',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${widget.device.totalConsumption} Wh',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCircle(String day, bool isSelected) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primaryBlue : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : Colors.grey,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String mode, Color color) {
    final isSelected = _selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });

        // Update device settings in provider
        Provider.of<HomeProvider>(
          context,
          listen: false,
        ).updateDeviceSettings(widget.device.id, {'mode': mode});
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: AppAnimations.shortDuration,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey[200],
              shape: BoxShape.circle,
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child: Text(
                mode[0],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mode,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
