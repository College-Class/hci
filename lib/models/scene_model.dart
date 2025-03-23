import 'package:flutter/material.dart';

class Scene {
  final String id;
  final String name;
  final TimeOfDay scheduleTime;
  final List<String> deviceIds;
  final Map<String, dynamic> deviceSettings;
  final bool isActive;
  final List<String> deviceImageUrls;

  Scene({
    required this.id,
    required this.name,
    required this.scheduleTime,
    required this.deviceIds,
    required this.deviceSettings,
    this.isActive = false,
    required this.deviceImageUrls,
  });

  Scene copyWith({
    String? id,
    String? name,
    TimeOfDay? scheduleTime,
    List<String>? deviceIds,
    Map<String, dynamic>? deviceSettings,
    bool? isActive,
    List<String>? deviceImageUrls,
  }) {
    return Scene(
      id: id ?? this.id,
      name: name ?? this.name,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      deviceIds: deviceIds ?? this.deviceIds,
      deviceSettings: deviceSettings ?? this.deviceSettings,
      isActive: isActive ?? this.isActive,
      deviceImageUrls: deviceImageUrls ?? this.deviceImageUrls,
    );
  }
}

// Helper method to format time display
String formatTimeOfDay(TimeOfDay timeOfDay) {
  final hours = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
  final minutes = timeOfDay.minute.toString().padLeft(2, '0');
  final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hours:$minutes $period';
}
