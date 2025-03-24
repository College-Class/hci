class Group {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<String> deviceIds;
  final bool isActive;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.deviceIds,
    this.isActive = false,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    List<String>? deviceIds,
    bool? isActive,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      deviceIds: deviceIds ?? this.deviceIds,
      isActive: isActive ?? this.isActive,
    );
  }
} 