import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  bool isPremium;

  @HiveField(4)
  DateTime? premiumExpiryDate;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime lastActive;

  @HiveField(7)
  int totalDreams;

  @HiveField(8)
  int lucidDreams;

  @HiveField(9)
  int currentStreak;

  @HiveField(10)
  int longestStreak;

  @HiveField(11)
  DateTime? lastDreamDate;

  @HiveField(12)
  Map<String, dynamic> preferences;

  @HiveField(13)
  List<String> achievements;

  @HiveField(14)
  int experiencePoints;

  User({
    required this.id,
    required this.name,
    this.email,
    this.isPremium = false,
    this.premiumExpiryDate,
    required this.createdAt,
    required this.lastActive,
    this.totalDreams = 0,
    this.lucidDreams = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastDreamDate,
    this.preferences = const {},
    this.achievements = const [],
    this.experiencePoints = 0,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isPremium,
    DateTime? premiumExpiryDate,
    DateTime? createdAt,
    DateTime? lastActive,
    int? totalDreams,
    int? lucidDreams,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastDreamDate,
    Map<String, dynamic>? preferences,
    List<String>? achievements,
    int? experiencePoints,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      totalDreams: totalDreams ?? this.totalDreams,
      lucidDreams: lucidDreams ?? this.lucidDreams,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastDreamDate: lastDreamDate ?? this.lastDreamDate,
      preferences: preferences ?? this.preferences,
      achievements: achievements ?? this.achievements,
      experiencePoints: experiencePoints ?? this.experiencePoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'totalDreams': totalDreams,
      'lucidDreams': lucidDreams,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastDreamDate': lastDreamDate?.toIso8601String(),
      'preferences': preferences,
      'achievements': achievements,
      'experiencePoints': experiencePoints,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isPremium: json['isPremium'] ?? false,
      premiumExpiryDate: json['premiumExpiryDate'] != null 
          ? DateTime.parse(json['premiumExpiryDate']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastActive: DateTime.parse(json['lastActive']),
      totalDreams: json['totalDreams'] ?? 0,
      lucidDreams: json['lucidDreams'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastDreamDate: json['lastDreamDate'] != null 
          ? DateTime.parse(json['lastDreamDate']) 
          : null,
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      achievements: List<String>.from(json['achievements'] ?? []),
      experiencePoints: json['experiencePoints'] ?? 0,
    );
  }

  // Méthodes utilitaires
  void addDream() {
    totalDreams++;
    lastDreamDate = DateTime.now();
    updateStreak();
  }

  void addLucidDream() {
    lucidDreams++;
    addDream();
  }

  void updateStreak() {
    final now = DateTime.now();
    if (lastDreamDate != null) {
      final difference = now.difference(lastDreamDate!).inDays;
      if (difference <= 1) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else if (difference > 1) {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }
  }

  void addExperience(int points) {
    experiencePoints += points;
  }

  void addAchievement(String achievement) {
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
    }
  }
}
