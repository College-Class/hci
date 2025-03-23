class Room {
  final String id;
  final String name;
  final List<String> deviceIds;
  final String imageUrl;
  final double totalConsumption;
  final int totalDevices;
  final int activeDevices;
  final double kwhUsage;

  Room({
    required this.id,
    required this.name,
    required this.deviceIds,
    required this.imageUrl,
    required this.totalConsumption,
    required this.totalDevices,
    required this.activeDevices,
    required this.kwhUsage,
  });

  Room copyWith({
    String? id,
    String? name,
    List<String>? deviceIds,
    String? imageUrl,
    double? totalConsumption,
    int? totalDevices,
    int? activeDevices,
    double? kwhUsage,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceIds: deviceIds ?? this.deviceIds,
      imageUrl: imageUrl ?? this.imageUrl,
      totalConsumption: totalConsumption ?? this.totalConsumption,
      totalDevices: totalDevices ?? this.totalDevices,
      activeDevices: activeDevices ?? this.activeDevices,
      kwhUsage: kwhUsage ?? this.kwhUsage,
    );
  }
}
