import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../models/room_model.dart';
import '../models/scene_model.dart';
import '../models/user_model.dart';

class HomeProvider with ChangeNotifier {
  // Mock user data
  User _currentUser = User(
    id: 'usr001',
    name: 'User',
    email: 'user@example.com',
    roomIds: ['rm001', 'rm002', 'rm003', 'rm004'],
    sceneIds: ['sc001'],
    preferences: {'darkMode': false, 'notifications': true},
  );

  // Mock rooms data
  final Map<String, Room> _rooms = {
    'rm001': Room(
      id: 'rm001',
      name: 'Living room',
      deviceIds: ['dev001', 'dev002', 'dev003', 'dev004'],
      imageUrl: 'assets/images/living_room.jpg',
      totalConsumption: 300,
      totalDevices: 8,
      activeDevices: 5,
      kwhUsage: 9.1,
    ),
    'rm002': Room(
      id: 'rm002',
      name: 'Bedroom',
      deviceIds: ['dev005', 'dev006'],
      imageUrl: 'assets/images/bedroom.jpg',
      totalConsumption: 300,
      totalDevices: 8,
      activeDevices: 5,
      kwhUsage: 9.1,
    ),
    'rm003': Room(
      id: 'rm003',
      name: 'Kitchen',
      deviceIds: ['dev007', 'dev008'],
      imageUrl: 'assets/images/kitchen.jpg',
      totalConsumption: 300,
      totalDevices: 8,
      activeDevices: 5,
      kwhUsage: 9.1,
    ),
    'rm004': Room(
      id: 'rm004',
      name: 'Bathroom',
      deviceIds: ['dev009', 'dev010'],
      imageUrl: 'assets/images/bathroom.jpg',
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
      imageUrl: 'assets/images/smart_light.jpg',
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
      imageUrl: 'assets/images/air_conditioner.jpg',
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
      imageUrl: 'assets/images/fan.jpg',
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
      imageUrl: 'assets/images/tv.jpg',
      lastUsed: DateTime.now(),
      timeUsed: const Duration(hours: 2, minutes: 24),
    ),
  };

  // Mock scenes data
  final Map<String, Scene> _scenes = {
    'sc001': Scene(
      id: 'sc001',
      name: 'Daily Scene',
      scheduleTime: const TimeOfDay(hour: 19, minute: 0),
      deviceIds: ['dev001', 'dev002', 'dev003'],
      deviceSettings: {
        'dev001': {'brightness': 70, 'color': 'warm'},
        'dev002': {'mode': 'cool', 'temperature': 24},
        'dev003': {'speed': 2},
      },
      isActive: true,
      deviceImageUrls: [
        'assets/images/smart_light.jpg',
        'assets/images/air_conditioner.jpg',
        'assets/images/fan.jpg',
      ],
    ),
  };

  // Getters
  User get currentUser => _currentUser;
  List<Room> get rooms => _rooms.values.toList();
  List<Device> get devices => _devices.values.toList();
  List<Scene> get scenes => _scenes.values.toList();

  List<Device> getDevicesForRoom(String roomId) {
    return _devices.values.where((device) => device.room == roomId).toList();
  }

  Room? getRoomById(String roomId) {
    return _rooms[roomId];
  }

  Device? getDeviceById(String deviceId) {
    return _devices[deviceId];
  }

  Scene? getSceneById(String sceneId) {
    return _scenes[sceneId];
  }

  // Methods to update data
  void toggleDeviceState(String deviceId) {
    final device = _devices[deviceId];
    if (device != null) {
      _devices[deviceId] = device.copyWith(isOn: !device.isOn);
      notifyListeners();
    }
  }

  void toggleSceneState(String sceneId) {
    final scene = _scenes[sceneId];
    if (scene != null) {
      _scenes[sceneId] = scene.copyWith(isActive: !scene.isActive);
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
      _devices[deviceId] = device.copyWith(additionalSettings: updatedSettings);
      notifyListeners();
    }
  }

  double get todayConsumption {
    return 25.0; // Mock value
  }

  double get totalConsumption {
    return 500.0; // Mock value
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
        sceneIds: [], // Empty list for new user
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
        sceneIds: [], // Empty list for new user
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
        sceneIds: [], // Empty list for new user
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
        sceneIds: [], // Empty list for new user
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
