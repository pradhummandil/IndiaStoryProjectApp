/// Response from `GET /api/profile`.
class ProfileResponse {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final String? bio;
  final String role;
  final bool active;
  final int level;
  final int readingStreak;
  final int totalReadingTime;
  final int totalXP;
  final String? coverUrl;
  final String? favoriteState;
  final String? twitter;
  final String? instagram;
  final String? linkedin;
  final String? website;
  final DateTime? lastActiveAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileResponse({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.bio,
    this.role = 'Reader',
    this.active = true,
    this.level = 1,
    this.readingStreak = 0,
    this.totalReadingTime = 0,
    this.totalXP = 0,
    this.coverUrl,
    this.favoriteState,
    this.twitter,
    this.instagram,
    this.linkedin,
    this.website,
    this.lastActiveAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String? ?? 'Reader',
      active: json['active'] as bool? ?? true,
      level: (json['level'] as num?)?.toInt() ?? 1,
      readingStreak: (json['readingStreak'] as num?)?.toInt() ?? 0,
      totalReadingTime: (json['totalReadingTime'] as num?)?.toInt() ?? 0,
      totalXP: (json['totalXP'] as num?)?.toInt() ?? 0,
      coverUrl: json['coverUrl'] as String?,
      favoriteState: json['favoriteState'] as String?,
      twitter: json['twitter'] as String?,
      instagram: json['instagram'] as String?,
      linkedin: json['linkedin'] as String?,
      website: json['website'] as String?,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
