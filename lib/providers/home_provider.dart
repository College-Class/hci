import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../models/room_model.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

class HomeProvider with ChangeNotifier {
  // Mock user data
  User _currentUser = User(
    id: 'usr001',
    name: 'User',
    email: 'user@example.com',
    roomIds: ['rm001', 'rm002', 'rm003', 'rm004'],
    groupIds: ['gr001'],
    preferences: {'darkMode': false, 'notifications': true},
  );

  // Mock rooms data
  final Map<String, Room> _rooms = {
    'rm001': Room(
      id: 'rm001',
      name: 'Living room',
      deviceIds: ['dev001', 'dev002', 'dev003', 'dev004'],
      imageUrl:
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=1000&auto=format&fit=crop',
      totalConsumption: 300,
      totalDevices: 8,
      activeDevices: 5,
      kwhUsage: 9.1,
    ),
    'rm002': Room(
      id: 'rm002',
      name: 'Bedroom',
      deviceIds: ['dev005', 'dev006'],
      imageUrl:
          'https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=1000&auto=format&fit=crop',
      totalConsumption: 300,
      totalDevices: 8,
      activeDevices: 5,
      kwhUsage: 9.1,
    ),
    'rm003': Room(
      id: 'rm003',
      name: 'Kitchen',
      deviceIds: ['dev007', 'dev008'],
      imageUrl:
          'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?q=80&w=1000&auto=format&fit=crop',
      totalConsumption: 300,
      totalDevices: 8,
      activeDevices: 5,
      kwhUsage: 9.1,
    ),
    'rm004': Room(
      id: 'rm004',
      name: 'Bathroom',
      deviceIds: ['dev009', 'dev010'],
      imageUrl:
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000&auto=format&fit=crop',
      totalConsumption: 300,
      totalDevices: 8,
      activeDevices: 5,
      kwhUsage: 9.1,
    ),
  };

  // Mock devices data
  final Map<String, Device> _devices = {
    'dev001': Device(
      id: 'dev001',
      name: 'Smart Lighting',
      model: 'LFG1',
      type: DeviceType.smartLight,
      connectionType: ConnectionType.wifi,
      room: 'rm001',
      isOn: true,
      currentConsumption: 1.3,
      totalConsumption: 172,
      imageUrl:
          'https://images.unsplash.com/photo-1555663823-23e8867f739c?q=80&w=640&auto=format&fit=crop',
      lastUsed: DateTime.now(),
      timeUsed: const Duration(hours: 2, minutes: 32),
    ),
    'dev002': Device(
      id: 'dev002',
      name: 'Air Condition',
      model: 'LFG1',
      type: DeviceType.airConditioner,
      connectionType: ConnectionType.wifi,
      room: 'rm001',
      isOn: true,
      currentConsumption: 1.3,
      totalConsumption: 172,
      imageUrl:
          'https://images.unsplash.com/photo-1652227053304-d1efa6608d97?q=80&w=640&auto=format&fit=crop',
      lastUsed: DateTime.now(),
      timeUsed: const Duration(hours: 2, minutes: 32),
      additionalSettings: {
        'mode': 'Heat',
        'temperature': 24,
        'fanSpeed': 'Auto',
      },
    ),
    'dev003': Device(
      id: 'dev003',
      name: 'Fan',
      model: 'LFG1',
      type: DeviceType.fan,
      connectionType: ConnectionType.wifi,
      room: 'rm001',
      isOn: true,
      currentConsumption: 0.5,
      totalConsumption: 87,
      imageUrl:
          'https://images.unsplash.com/photo-1565151443833-29bf2ba5dd8d?q=80&w=640&auto=format&fit=crop',
      lastUsed: DateTime.now(),
      timeUsed: const Duration(hours: 2, minutes: 24),
    ),
    'dev004': Device(
      id: 'dev004',
      name: 'Smart Television',
      model: 'LFG1',
      type: DeviceType.television,
      connectionType: ConnectionType.bluetooth,
      room: 'rm001',
      isOn: false,
      currentConsumption: 0,
      totalConsumption: 145,
      imageUrl:
          'https://images.unsplash.com/photo-1593784991095-a205069470b6?q=80&w=640&auto=format&fit=crop',
      lastUsed: DateTime.now(),
      timeUsed: const Duration(hours: 2, minutes: 24),
    ),
  };

  // Mock groups data (renamed from scenes)
  final Map<String, Group> _groups = {
    'gr001': Group(
      id: 'gr001',
      name: 'Morning Routine',
      description: 'Activates all morning devices',
      type: 'morning',
      deviceIds: ['dev001', 'dev002', 'dev003'],
      isActive: true,
    ),
    'gr002': Group(
      id: 'gr002',
      name: 'Night Mode',
      description: 'Dims lights and sets comfortable temperature',
      type: 'night',
      deviceIds: ['dev001', 'dev002'],
      isActive: false,
    ),
    'gr003': Group(
      id: 'gr003',
      name: 'Movie Time',
      description: 'Perfect lighting for movie watching',
      type: 'movie',
      deviceIds: ['dev001', 'dev004'],
      isActive: false,
    ),
  };

  // Getters
  User get currentUser => _currentUser;
  List<Room> get rooms => _rooms.values.toList();
  List<Device> get devices => _devices.values.toList();
  List<Group> get groups => _groups.values.toList();

  // Mock data for power consumption graph
  List<Map<String, dynamic>> get weeklyConsumptionData {
    // Generate data for the last 7 days
    final now = DateTime.now();
    List<Map<String, dynamic>> result = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Generate a value between 1.0 and 4.5
      final consumptionValue = 1.0 + (date.day % 5) * 0.7;

      result.add({
        'date': date,
        'day': _getWeekdayShort(date.weekday),
        'consumption': consumptionValue,
      });
    }

    return result;
  }

  // Mock data for monthly power consumption
  List<Map<String, dynamic>> get monthlyConsumptionData {
    // Generate data for the last 6 months
    final now = DateTime.now();
    List<Map<String, dynamic>> result = [];

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      // Generate a value between 20 and 45 kWh for monthly consumption
      final consumptionValue = 20.0 + (date.month % 6) * 5.0;

      result.add({
        'date': date,
        'month': _getMonthShort(date.month),
        'consumption': consumptionValue,
      });
    }

    return result;
  }

  // Helper to get shortened weekday name
  String _getWeekdayShort(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Helper to get shortened month name
  String _getMonthShort(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  List<Device> getDevicesForRoom(String roomId) {
    return _devices.values.where((device) => device.room == roomId).toList();
  }

  Room? getRoomById(String roomId) {
    return _rooms[roomId];
  }

  Device? getDeviceById(String deviceId) {
    return _devices[deviceId];
  }

  Group? getGroupById(String groupId) {
    return _groups[groupId];
  }

  // Methods to update data
  void toggleDeviceState(String deviceId) {
    final device = _devices[deviceId];
    if (device != null) {
      final bool newState = !device.isOn;

      // Update the device's state
      _devices[deviceId] = device.copyWith(
        isOn: newState,
        currentConsumption: newState ? _getDeviceConsumption(device) : 0.0,
        lastUsed: newState ? DateTime.now() : device.lastUsed,
      );

      // Update the active device count in the room
      final room = _rooms[device.room];
      if (room != null) {
        final activeDevices =
            getDevicesForRoom(device.room).where((d) => d.isOn).length;
        _rooms[device.room] = room.copyWith(activeDevices: activeDevices);
      }

      notifyListeners();
    }
  }

  // Helper method to get appropriate consumption based on device type
  double _getDeviceConsumption(Device device) {
    switch (device.type) {
      case DeviceType.airConditioner:
        // AC consumes more power
        return 2.4;
      case DeviceType.smartLight:
        // Smart light is efficient
        final int brightness =
            device.additionalSettings['brightness'] as int? ?? 70;
        return 0.3 +
            (brightness / 100) * 1.0; // Base 0.3W + up to 1.0W more at 100%
      case DeviceType.television:
        // TV consumption
        return 1.8;
      case DeviceType.fan:
        // Fan consumption - based on speed
        final int speed = device.additionalSettings['speed'] as int? ?? 3;
        return 0.5 + (speed / 5) * 0.5; // 0.5W to 1.0W based on speed
      default:
        return 1.0;
    }
  }

  void toggleGroupState(String groupId) {
    final group = _groups[groupId];
    if (group != null) {
      final newState = !group.isActive;
      _groups[groupId] = group.copyWith(isActive: newState);

      // Toggle all devices in the group
      for (final deviceId in group.deviceIds) {
        final device = _devices[deviceId];
        if (device != null && device.isOn != newState) {
          toggleDeviceState(deviceId);
        }
      }

      notifyListeners();
    }
  }

  void updateDeviceSettings(String deviceId, Map<String, dynamic> newSettings) {
    final device = _devices[deviceId];
    if (device != null) {
      final Map<String, dynamic> updatedSettings = {
        ...device.additionalSettings,
        ...newSettings,
      };

      double newConsumption = device.currentConsumption;
      if (device.isOn) {
        // Update consumption based on new settings
        if (device.type == DeviceType.smartLight &&
            newSettings.containsKey('brightness')) {
          final int brightness = newSettings['brightness'] as int;
          newConsumption = 0.3 + (brightness / 100) * 1.0;
        } else if (device.type == DeviceType.fan &&
            newSettings.containsKey('speed')) {
          final int speed = newSettings['speed'] as int;
          newConsumption = 0.5 + (speed / 5) * 0.5;
        }
      }

      _devices[deviceId] = device.copyWith(
        additionalSettings: updatedSettings,
        currentConsumption: newConsumption,
      );

      notifyListeners();
    }
  }

  // Update device usage time - should be called periodically in a real app
  void updateDeviceUsageTime(String deviceId) {
    final device = _devices[deviceId];
    if (device != null && device.isOn) {
      final now = DateTime.now();
      final difference = now.difference(device.lastUsed);

      // Add the time difference to the total usage
      final newTimeUsed = Duration(
        seconds: device.timeUsed.inSeconds + difference.inSeconds,
      );

      // Update the consumption based on time used
      final additionalConsumption =
          (difference.inMinutes / 60) * device.currentConsumption;

      _devices[deviceId] = device.copyWith(
        lastUsed: now,
        timeUsed: newTimeUsed,
        totalConsumption: device.totalConsumption + additionalConsumption,
      );
    }
  }

  // Update all active devices' usage time
  void updateAllDevicesUsage() {
    for (final device in devices.where((d) => d.isOn)) {
      updateDeviceUsageTime(device.id);
    }
    notifyListeners();
  }

  // Get filtered devices by type and search query
  List<Device> getFilteredDevices({DeviceType? type, String? searchQuery}) {
    return devices.where((device) {
      // Apply type filter if specified
      if (type != null && device.type != type) {
        return false;
      }

      // Apply search query if specified
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return device.name.toLowerCase().contains(query) ||
            device.model.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  double get todayConsumption {
    double total = 0.0;
    for (final device in devices) {
      if (device.isOn) {
        total += device.currentConsumption;
      }
    }
    return total;
  }

  double get totalConsumption {
    return devices.fold(0.0, (sum, device) => sum + device.totalConsumption);
  }

  int get airConditionersCount {
    return devices.where((d) => d.type == DeviceType.airConditioner).length;
  }

  int get smartLightsCount {
    return devices.where((d) => d.type == DeviceType.smartLight).length;
  }

  int get televisionCount {
    return devices.where((d) => d.type == DeviceType.television).length;
  }

  // Login methods (mock)
  Future<bool> login(String email, String password) async {
    // In a real app, this would validate credentials with a backend service
    try {
      _currentUser = User(
        id: '1',
        name: 'John Doe',
        email: email,
        profileImageUrl: 'assets/images/user_profile.jpg',
        roomIds: [], // Empty list for new user
        groupIds: [], // Empty list for new user
        preferences: {}, // Default preferences
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithSocial(String email, String name) async {
    // In a real app, this would handle social authentication
    try {
      _currentUser = User(
        id: '1',
        name: name,
        email: email,
        profileImageUrl: 'assets/images/user_profile.jpg',
        roomIds: [], // Empty list for new user
        groupIds: [], // Empty list for new user
        preferences: {}, // Default preferences
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    // In a real app, this would handle Google authentication
    try {
      _currentUser = User(
        id: '2',
        name: 'Google User',
        email: 'google_user@example.com',
        profileImageUrl: 'assets/images/user_profile.jpg',
        roomIds: [], // Empty list for new user
        groupIds: [], // Empty list for new user
        preferences: {}, // Default preferences
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithApple() async {
    // In a real app, this would handle Apple authentication
    try {
      _currentUser = User(
        id: '3',
        name: 'Apple User',
        email: 'apple_user@example.com',
        profileImageUrl: 'assets/images/user_profile.jpg',
        roomIds: [], // Empty list for new user
        groupIds: [], // Empty list for new user
        preferences: {}, // Default preferences
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock logout
    notifyListeners();
  }
}
