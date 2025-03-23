import 'package:flutter/material.dart';

enum DeviceType { smartLight, airConditioner, television, fan, other }

enum ConnectionType { wifi, bluetooth, zigbee, other }

class Device {
  final String id;
  final String name;
  final String model;
  final DeviceType type;
  final ConnectionType connectionType;
  final String room;
  bool isOn;
  double currentConsumption;
  double totalConsumption;
  final String imageUrl;
  DateTime lastUsed;
  Duration timeUsed;
  Map<String, dynamic> additionalSettings;

  Device({
    required this.id,
    required this.name,
    required this.model,
    required this.type,
    required this.connectionType,
    required this.room,
    this.isOn = false,
    this.currentConsumption = 0.0,
    this.totalConsumption = 0.0,
    required this.imageUrl,
    required this.lastUsed,
    required this.timeUsed,
    this.additionalSettings = const {},
  });

  IconData get icon {
    switch (type) {
      case DeviceType.smartLight:
        return Icons.lightbulb_outline;
      case DeviceType.airConditioner:
        return Icons.air;
      case DeviceType.television:
        return Icons.tv;
      case DeviceType.fan:
        return Icons.thermostat;
      case DeviceType.other:
        return Icons.devices_other;
    }
  }

  Device copyWith({
    String? id,
    String? name,
    String? model,
    DeviceType? type,
    ConnectionType? connectionType,
    String? room,
    bool? isOn,
    double? currentConsumption,
    double? totalConsumption,
    String? imageUrl,
    DateTime? lastUsed,
    Duration? timeUsed,
    Map<String, dynamic>? additionalSettings,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      type: type ?? this.type,
      connectionType: connectionType ?? this.connectionType,
      room: room ?? this.room,
      isOn: isOn ?? this.isOn,
      currentConsumption: currentConsumption ?? this.currentConsumption,
      totalConsumption: totalConsumption ?? this.totalConsumption,
      imageUrl: imageUrl ?? this.imageUrl,
      lastUsed: lastUsed ?? this.lastUsed,
      timeUsed: timeUsed ?? this.timeUsed,
      additionalSettings: additionalSettings ?? this.additionalSettings,
    );
  }
}
