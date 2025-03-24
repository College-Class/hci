class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final List<String> roomIds;
  final List<String> groupIds;
  final Map<String, dynamic> preferences;
  final bool isPremium;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.roomIds,
    required this.groupIds,
    required this.preferences,
    this.isPremium = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    List<String>? roomIds,
    List<String>? groupIds,
    Map<String, dynamic>? preferences,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      roomIds: roomIds ?? this.roomIds,
      groupIds: groupIds ?? this.groupIds,
      preferences: preferences ?? this.preferences,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
